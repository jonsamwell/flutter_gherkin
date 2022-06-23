import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:collection/collection.dart';

typedef StepFn = Future<StepResult> Function(
  TestDependencies dependencies,
  bool skip,
);

typedef StartAppFn = Future<void> Function(World world);

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
  final FlutterTestConfiguration configuration;
  final StartAppFn appMainFunction;
  final Timeout scenarioExecutionTimeout;
  final AggregatedReporter _reporter = AggregatedReporter();
  Hook? _hook;
  Iterable<ExecutableStep>? _executableSteps;
  Iterable<CustomParameter>? _customParameters;

  late final IntegrationTestWidgetsFlutterBinding _binding;

  AggregatedReporter get reporter => _reporter;
  Hook get hook => _hook!;
  LiveTestWidgetsFlutterBindingFramePolicy? get framePolicy => null;

  GherkinIntegrationTestRunner(
    this.configuration,
    this.appMainFunction, {
    this.scenarioExecutionTimeout = const Timeout(Duration(minutes: 10)),
  }) {
    configuration.prepare();
    _registerReporters(configuration.reporters);
    _hook = _registerHooks(configuration.hooks);
    _customParameters =
        _registerCustomParameters(configuration.customStepParameterDefinitions);
    _executableSteps = _registerStepDefinitions(
      configuration.stepDefinitions!,
      _customParameters!,
    );
  }

  Future<void> run() async {
    _binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    _binding.framePolicy =
        framePolicy ?? LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;

    tearDownAll(
      () {
        onRunComplete();
      },
    );

    _safeInvokeFuture(() async => await hook.onBeforeRun(configuration));
    _safeInvokeFuture(() async => await reporter.test.onStarted.maybeCall());

    onRun();
  }

  void onRun();

  void onRunComplete() {
    _safeInvokeFuture(() async => await reporter.test.onFinished.maybeCall());
    _safeInvokeFuture(() async => await hook.onAfterRun(configuration));
    setTestResultData(_binding);
    _safeInvokeFuture(() async => await reporter.dispose());
  }

  void setTestResultData(IntegrationTestWidgetsFlutterBinding binding) {
    final json = (reporter).serialize();
    binding.reportData = {'gherkin_reports': json};
  }

  @protected
  void runFeature({
    required String name,
    required void Function() run,
    Iterable<String>? tags,
  }) {
    group(
      name,
      () {
        run();
      },
    );
  }

  @protected
  Future<void> onBeforeRunFeature({
    required String name,
    required String path,
    Iterable<String>? tags,
  }) async {
    final debugInformation = RunnableDebugInformation(path, 0, name);
    final featureTags =
        (tags ?? const Iterable<Tag>.empty()).map((t) => Tag(t.toString(), 0));
    await reporter.feature.onStarted.maybeCall(
      FeatureMessage(
        name: name,
        context: debugInformation,
        tags: featureTags.toList(),
      ),
    );
  }

  @protected
  Future<void> onAfterRunFeature({
    required String name,
    required String path,
    required List<String>? tags,
  }) async {
    final debugInformation = RunnableDebugInformation(path, 0, name);
    await reporter.feature.onFinished.maybeCall(
      FeatureMessage(
        name: name,
        context: debugInformation,
        tags: (tags ?? const Iterable<String>.empty())
            .map(
              (t) => Tag(t.toString(), 0),
            )
            .toList(growable: false),
      ),
    );
  }

  @protected
  void runScenario({
    required String name,
    required Iterable<String>? tags,
    required List<StepFn> steps,
    required String path,
    Future<void> Function()? onBefore,
    Future<void> Function()? onAfter,
  }) {
    if (_evaluateTagFilterExpression(configuration.tagExpression, tags)) {
      testWidgets(
        name,
        (WidgetTester tester) async {
          if (onBefore != null) {
            await onBefore();
          }
          bool failed = false;

          final debugInformation = RunnableDebugInformation(path, 0, name);
          final scenarioTags = (tags ?? const Iterable<Tag>.empty()).map(
            (t) => Tag(t.toString(), 0),
          );
          final dependencies = await createTestDependencies(
            configuration,
            tester,
          );

          try {
            await hook.onBeforeScenario(
              configuration,
              name,
              scenarioTags,
            );

            await startApp(
              tester,
              dependencies.world,
            );

            await hook.onAfterScenarioWorldCreated(
              dependencies.world,
              name,
              scenarioTags,
            );

            await reporter.scenario.onStarted.maybeCall(
              ScenarioMessage(
                name: name,
                context: debugInformation,
                tags: scenarioTags.toList(),
              ),
            );
            var hasToSkip = false;
            for (int i = 0; i < steps.length; i++) {
              try {
                final result = await steps[i](dependencies, hasToSkip);
                if (_isNegativeResult(result.result)) {
                  failed = true;
                  hasToSkip = true;
                }
              } catch (e) {
                failed = true;
                hasToSkip = true;
              }
            }
          } finally {
            await reporter.scenario.onFinished.maybeCall(
              ScenarioMessage(
                name: name,
                context: debugInformation,
                hasPassed: !failed,
              ),
            );

            await hook.onAfterScenario(
              configuration,
              name,
              scenarioTags,
              passed: !failed,
            );

            if (onAfter != null) {
              await onAfter();
            }

            // need to pump so app can finalise
            await _pumpAndSettle(tester);

            cleanUpScenarioRun(dependencies);
          }
        },
        timeout: scenarioExecutionTimeout,
        semanticsEnabled: configuration.semanticsEnabled,
      );
    } else {
      _safeInvokeFuture(
        () async => reporter.message(
          'Ignoring scenario `$name` as tag expression `${configuration.tagExpression}` not satisfied',
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
    await appMainFunction(world);

    // need to pump so app is initialised
    await _pumpAndSettle(tester);
  }

  @protected
  Future<TestDependencies> createTestDependencies(
    TestConfiguration configuration,
    WidgetTester tester,
  ) async {
    World? world;
    final attachmentManager =
        await configuration.getAttachmentManager(configuration);

    if (configuration.createWorld != null) {
      world = await configuration.createWorld!(configuration);
    }

    world = world ?? FlutterWidgetTesterWorld();
    world.setAttachmentManager(attachmentManager);

    (world as FlutterWorld).setAppAdapter(
      WidgetTesterAppDriverAdapter(
        rawAdapter: tester,
        binding: _binding,
        waitImplicitlyAfterAction: configuration is FlutterTestConfiguration
            ? (configuration).waitImplicitlyAfterAction
            : true,
      ),
    );

    return TestDependencies(
      world,
      attachmentManager,
    );
  }

  @protected
  Future<StepResult> runStep({
    required String name,
    required Iterable<String> multiLineStrings,
    required dynamic table,
    required TestDependencies dependencies,
    required bool skip,
  }) async {
    final executable = _executableSteps!.firstWhereOrNull(
      (s) => s.expression.isMatch(name),
    );

    if (executable == null) {
      final message = 'Step definition not found for text: `$name`';
      throw GherkinStepNotDefinedException(message);
    }

    var parameters = _getStepParameters(
      step: name,
      multiLineStrings: multiLineStrings,
      table: table,
      code: executable,
    );

    await _onBeforeStepRun(
      world: dependencies.world,
      step: name,
      table: table,
      multiLineStrings: multiLineStrings,
    );

    StepResult? result;

    if (skip) {
      result = StepResult(
        0,
        StepExecutionResult.skipped,
        resultReason: 'Previous step(s) failed',
      );
    } else {
      for (int i = 0; i < configuration.stepMaxRetries + 1; i++) {
        result = await executable.step.run(
          dependencies.world,
          reporter,
          configuration.defaultTimeout,
          parameters,
        );
        if (!_isNegativeResult(result.result)) {
          break;
        } else {
          await Future.delayed(configuration.retryDelay);
        }
      }
    }
    await _onAfterStepRun(
      name,
      result!,
      dependencies,
    );

    return result;
  }

  @protected
  void cleanUpScenarioRun(TestDependencies dependencies) {
    _safeInvokeFuture(
      () async => dependencies.attachmentManager.dispose(),
    );
    _safeInvokeFuture(
      () async => dependencies.world.dispose(),
    );
  }

  void _registerReporters(Iterable<Reporter>? reporters) {
    if (reporters != null) {
      for (var r in reporters) {
        _reporter.addReporter(r);
      }
    }
  }

  Hook _registerHooks(Iterable<Hook>? hooks) {
    final hook = AggregatedHook();
    if (hooks != null) {
      hook.addHooks(hooks);
    }

    return hook;
  }

  Iterable<CustomParameter> _registerCustomParameters(
    Iterable<CustomParameter>? customParameters,
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
            GherkinExpression(s.pattern as RegExp, customParameters),
            s,
          ),
        )
        .toList(growable: false);
  }

  Iterable<dynamic> _getStepParameters({
    required String step,
    required Iterable<String> multiLineStrings,
    required ExecutableStep code,
    GherkinTable? table,
  }) {
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
    await hook.onAfterStep(
      dependencies.world,
      step,
      result,
    );

    await reporter.step.onFinished.maybeCall(
      StepMessage(
        name: step,
        context: RunnableDebugInformation('', 0, step),
        result: result,
        attachments: dependencies.attachmentManager
            .getAttachmentsForContext(step)
            .toList(),
      ),
    );
  }

  Future<void> _onBeforeStepRun({
    required World world,
    required String step,
    required Iterable<String> multiLineStrings,
    GherkinTable? table,
  }) async {
    await hook.onBeforeStep(world, step);
    await reporter.step.onStarted.maybeCall(
      StepMessage(
        name: step,
        context: RunnableDebugInformation('', 0, step),
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
    String? tagExpression,
    Iterable<String>? tags,
  ) {
    return tagExpression == null || tagExpression.isEmpty
        ? true
        : _tagExpressionEvaluator.evaluate(
            tagExpression,
            tags!.toList(growable: false),
          );
  }

  bool _isNegativeResult(StepExecutionResult result) {
    return result == StepExecutionResult.error ||
        result == StepExecutionResult.fail ||
        result == StepExecutionResult.timeout;
  }

  Future<void> _pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 200),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 2000),
    );
  }
}
