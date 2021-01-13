import 'package:flutter_gherkin/flutter_gherkin_integration_test.dart';
import 'package:flutter_gherkin/src/flutter/adapters/widget_tester_app_driver_adapter.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_world.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class TestDependencies {
  final World world;
  final AttachmentManager attachmentManager;

  TestDependencies(
    this.world,
    this.attachmentManager,
  );
}

abstract class GherkinIntegrationTestRunner {
  final TagExpressionEvaluator _tagExpressionEvaluator =
      TagExpressionEvaluator();
  final TestConfiguration configuration;
  final void Function(World world) appMainFunction;
  Reporter _reporter;
  Hook _hook;
  Iterable<ExecutableStep> _executableSteps;
  Iterable<CustomParameter> _customParameters;

  IntegrationTestWidgetsFlutterBinding _binding;

  Reporter get reporter => _reporter;
  Hook get hook => _hook;

  Timeout scenarioExecutionTimeout = const Timeout(Duration(minutes: 10));

  GherkinIntegrationTestRunner(
    this.configuration,
    this.appMainFunction,
  ) {
    configuration.prepare();
    _reporter = _registerReporters(configuration.reporters);
    _hook = _registerHooks(configuration.hooks);
    _customParameters =
        _registerCustomParameters(configuration.customStepParameterDefinitions);
    _executableSteps = _registerStepDefinitions(
      configuration.stepDefinitions,
      _customParameters,
    );
  }

  Future<void> run() async {
    _binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    _safeInvokeFuture(() async => await reporter.onTestRunStarted());

    onRun();

    tearDownAll(
      () {
        onRunComplete();
      },
    );
  }

  void onRun();

  void onRunComplete() {
    _safeInvokeFuture(() async => await reporter.onTestRunFinished());
    _safeInvokeFuture(() async => await hook.onAfterRun(configuration));
    setTestResultData(_binding);
    _safeInvokeFuture(() async => await reporter.dispose());
  }

  void setTestResultData(IntegrationTestWidgetsFlutterBinding binding) {
    if (reporter is SerializableReporter) {
      final json = (reporter as SerializableReporter).toJson();
      binding.reportData = {'gherkin_reports': json};
    }
  }

  @protected
  void runFeature(
    String name,
    Iterable<String> tags,
    void Function() runFeature,
  ) {
    group(
      name,
      () {
        final debugInformation = RunnableDebugInformation('', 0, name);
        final featureTags =
            (tags ?? Iterable<Tag>.empty()).map((t) => Tag(t, 0));
        _safeInvokeFuture(
          () async => await reporter.onFeatureStarted(
            StartedMessage(
              Target.feature,
              name,
              debugInformation,
              featureTags,
            ),
          ),
        );

        runFeature();

        _safeInvokeFuture(
          () async => reporter.onFeatureFinished(
            FinishedMessage(
              Target.feature,
              name,
              debugInformation,
            ),
          ),
        );
      },
    );
  }

  @protected
  void runScenario(
    String name,
    Iterable<String> tags,
    Future<void> Function(TestDependencies dependencies) runTest,
  ) {
    if (_evaluateTagFilterExpression(configuration.tagExpression, tags)) {
      testWidgets(
        name,
        (WidgetTester tester) async {
          final debugInformation = RunnableDebugInformation('', 0, name);
          final scenarioTags =
              (tags ?? Iterable<Tag>.empty()).map((t) => Tag(t, 0));
          final dependencies = await createTestDependencies(
            configuration,
            tester,
          );

          await _hook.onBeforeScenario(
            configuration,
            name,
            scenarioTags,
          );

          await startApp(
            tester,
            dependencies.world,
          );

          await _hook.onAfterScenarioWorldCreated(
            dependencies.world,
            name,
            scenarioTags,
          );

          await reporter.onScenarioStarted(
            StartedMessage(
              Target.scenario,
              name,
              debugInformation,
              scenarioTags,
            ),
          );

          await runTest(dependencies);

          await _reporter.onScenarioFinished(
            ScenarioFinishedMessage(
              name,
              debugInformation,
              true,
            ),
          );

          await _hook.onAfterScenario(
            configuration,
            name,
            scenarioTags,
          );

          cleanupScenarioRun(dependencies);
        },
        timeout: scenarioExecutionTimeout,
      );
    } else {
      _safeInvokeFuture(
        () async => reporter.message(
          'Ignoring scenario `${name}` as tag expression `${configuration.tagExpression}` not satisfied',
          MessageLevel.info,
        ),
      );
    }
  }

  @protected
  Future<void> startApp(
    WidgetTester tester,
    World world,
  ) async {
    appMainFunction(world);
    await tester.pumpAndSettle();
  }

  @protected
  Future<TestDependencies> createTestDependencies(
    TestConfiguration configuration,
    WidgetTester tester,
  ) async {
    World world;
    final attachmentManager =
        await configuration.getAttachmentManager(configuration);

    if (configuration.createWorld != null) {
      world = await configuration.createWorld(configuration);
    }

    world = world ?? FlutterWidgetTesterWorld();
    world.setAttachmentManager(attachmentManager);

    (world as FlutterWorld).setAppAdapter(WidgetTesterAppDriverAdapter(tester));

    return TestDependencies(
      world,
      attachmentManager,
    );
  }

  @protected
  Future<StepResult> runStep(
    String step,
    Iterable<String> multiLineStrings,
    dynamic table,
    TestDependencies dependencies,
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

    await _onBeforeStepRun(
      dependencies.world,
      step,
      table,
      multiLineStrings,
    );

    final result = await executable.step.run(
      dependencies.world,
      reporter,
      configuration.defaultTimeout,
      parameters,
    );

    await _onAfterStepRun(
      step,
      result,
      dependencies,
    );

    if (result.result == StepExecutionResult.fail) {
      throw TestFailure('Step: $step \n\n${result.resultReason}');
    } else if (result is ErroredStepResult) {
      throw result.exception;
    }

    return result;
  }

  @protected
  void cleanupScenarioRun(TestDependencies dependencies) {
    _safeInvokeFuture(
        () async => await dependencies.attachmentManager.dispose());
    _safeInvokeFuture(() async => await dependencies.world.dispose());
  }

  Reporter _registerReporters(Iterable<Reporter> reporters) {
    final reporter = AggregatedReporter();
    if (reporters != null) {
      reporters.forEach((r) => reporter.addReporter(r));
    }

    return reporter;
  }

  Hook _registerHooks(Iterable<Hook> hooks) {
    final hook = AggregatedHook();
    if (hooks != null) {
      hook.addHooks(hooks);
    }

    return hook;
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

  Future<void> _onAfterStepRun(
    String step,
    StepResult result,
    TestDependencies dependencies,
  ) async {
    await _hook.onAfterStep(
      dependencies.world,
      step,
      result,
    );
    await _reporter.onStepFinished(
      StepFinishedMessage(
        step,
        RunnableDebugInformation('', 0, step),
        result,
        dependencies.attachmentManager.getAttachmentsForContext(step),
      ),
    );
  }

  Future<void> _onBeforeStepRun(
    World world,
    String step,
    table,
    Iterable<String> multiLineStrings,
  ) async {
    await _hook.onBeforeStep(world, step);
    await reporter.onStepStarted(
      StepStartedMessage(
        step,
        RunnableDebugInformation('', 0, step),
        table: table,
        multilineString:
            multiLineStrings.isNotEmpty ? multiLineStrings.first : null,
      ),
    );
  }

  void _safeInvokeFuture(Future<void> Function() fn) async {
    try {
      await fn().catchError((_, __) {});
    } catch (_) {}
  }

  bool _evaluateTagFilterExpression(
    String tagExpression,
    List<String> tags,
  ) {
    return tagExpression == null || tagExpression.isEmpty
        ? true
        : _tagExpressionEvaluator.evaluate(tagExpression, tags);
  }
}
