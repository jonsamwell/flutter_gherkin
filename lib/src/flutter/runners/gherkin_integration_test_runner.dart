import 'package:flutter_gherkin/src/flutter/adapters/widget_tester_app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class _TestDependencies {
  final World world;
  final AttachmentManager attachmentManager;

  _TestDependencies(
    this.world,
    this.attachmentManager,
  );
}

abstract class GherkinIntegrationTestRunner {
  final TestConfiguration configuration;
  final void Function() appMainFunction;
  Reporter _reporter;
  Iterable<ExecutableStep> _executableSteps;
  Iterable<CustomParameter> _customParameters;

  Reporter get reporter => _reporter;

  Timeout scenarioExecutionTimeout = const Timeout(Duration(minutes: 10));

  GherkinIntegrationTestRunner(
    this.configuration,
    this.appMainFunction,
  ) {
    configuration.prepare();
    _reporter = _registerReporters(configuration.reporters);
    _customParameters =
        _registerCustomParameters(configuration.customStepParameterDefinitions);
    _executableSteps = _registerStepDefinitions(
      configuration.stepDefinitions,
      _customParameters,
    );
  }

  void run() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    onRun();
  }

  void onRun();

  @protected
  Future<void> startApp(WidgetTester tester) async {
    appMainFunction();
    await tester.pumpAndSettle();
  }

  @protected
  Future<_TestDependencies> createTestDependencies(
    TestConfiguration configuration,
    WidgetTester tester,
  ) async {
    World world;
    final attachmentManager =
        await configuration.getAttachmentManager(configuration);

    if (configuration.createWorld != null) {
      world = await configuration.createWorld(configuration);
      world.setAttachmentManager(attachmentManager);
    }

    world = world ?? FlutterWorld();

    (world as FlutterWorld).setAppAdapter(WidgetTesterAppDriverAdapter(tester));

    return _TestDependencies(
      world,
      attachmentManager,
    );
  }

  @protected
  Future<StepResult> runStep(
    String step,
    Iterable<String> multiLineStrings,
    dynamic table,
    World world,
  ) async {
    final executable = _executableSteps.firstWhere(
      (s) => s.expression.isMatch(step),
      orElse: () => null,
    );

    if (executable == null) {
      final message = 'Step definition not found for text: `$step`';
      throw GherkinStepNotDefinedException(message);
    }

    var parameters = _getStepParameters(
      step,
      multiLineStrings,
      table,
      executable,
    );

    // await reporter.onStepStarted(StepStartedMessage('some name', null));

    final result = await executable.step.run(
      world,
      reporter,
      configuration.defaultTimeout,
      parameters,
    );

    if (result.result == StepExecutionResult.fail) {
      throw TestFailure('Step: $step \n\n${result.resultReason}');
    } else if (result is ErroredStepResult) {
      throw result.exception;
    }

    return result;
  }

  Reporter _registerReporters(Iterable<Reporter> reporters) {
    final _reporter = AggregatedReporter();
    if (reporters != null) {
      reporters.forEach((r) => _reporter.addReporter(r));
    }

    return _reporter;
  }

  Iterable<CustomParameter> _registerCustomParameters(
    Iterable<CustomParameter> customParameters,
  ) {
    final parameters = <CustomParameter>[];

    parameters.add(FloatParameterLower());
    parameters.add(FloatParameterCamel());
    parameters.add(NumParameterLower());
    parameters.add(NumParameterCamel());
    parameters.add(IntParameterLower());
    parameters.add(IntParameterCamel());
    parameters.add(StringParameterLower());
    parameters.add(StringParameterCamel());
    parameters.add(WordParameterLower());
    parameters.add(WordParameterCamel());
    parameters.add(PluralParameter());
    if (customParameters != null && customParameters.isNotEmpty) {
      parameters.addAll(customParameters);
    }

    return parameters;
  }

  Iterable<ExecutableStep> _registerStepDefinitions(
    Iterable<StepDefinitionGeneric> stepDefinitions,
    Iterable<CustomParameter> customParameters,
  ) {
    return stepDefinitions
        .map(
          (s) => ExecutableStep(
            GherkinExpression(s.pattern, customParameters),
            s,
          ),
        )
        .toList(growable: false);
  }

  Iterable<dynamic> _getStepParameters(
    String step,
    Iterable<String> multiLineStrings,
    dynamic table,
    ExecutableStep code,
  ) {
    var parameters = code.expression.getParameters(step);
    if (multiLineStrings.isNotEmpty) {
      parameters = parameters.toList()..addAll(multiLineStrings);
    }

    if (table != null) {
      parameters = parameters.toList()..add(table);
    }

    return parameters;
  }
}
