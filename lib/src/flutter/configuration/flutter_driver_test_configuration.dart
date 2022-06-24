import 'dart:async';
import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin_with_driver.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class FlutterDriverTestConfiguration extends FlutterTestConfiguration {
  String? _observatoryDebuggerUri;

  FlutterDriverTestConfiguration({
    String? featurePath = 'features/*.*.feature',
    Iterable<Pattern>? features,
    super.featureDefaultLanguage = 'en',
    super.order = ExecutionOrder.random,
    super.defaultTimeout = const Duration(seconds: 10),
    super.featureFileMatcher = const IoFeatureFileAccessor(),
    super.featureFileReader = const IoFeatureFileAccessor(),
    super.stopAfterTestFailed = false,
    super.tagExpression,
    super.hooks,
    super.reporters = const [],
    super.createWorld,
    super.waitImplicitlyAfterAction = true,
    super.customStepParameterDefinitions,
    super.stepDefinitions,
    this.targetAppPath = 'test_driver/app.dart',
    this.targetAppWorkingDirectory,
    this.buildFlavour,
    this.targetDeviceId,
    this.runningAppProtocolEndpointUri,
    this.onBeforeFlutterDriverConnect,
    this.onAfterFlutterDriverConnect,
    this.restartAppBetweenScenarios = true,
    this.logFlutterProcessOutput = false,
    this.keepAppRunningAfterTests = false,
    this.verboseFlutterProcessLogs = false,
    this.build = true,
    this.buildMode = BuildMode.debug,
    this.flutterBuildTimeout = const Duration(seconds: 90),
    this.flutterDriverReconnectionDelay = const Duration(seconds: 2),
    this.flutterDriverMaxConnectionAttempts = 3,
  }) :
        // assert(featurePath != null && features != null),
        super(
          features: features ?? [RegExp(featurePath!)],
        );

  /// Provide a configuration object with default settings such as the reports and feature file location
  static FlutterDriverTestConfiguration standard(
    Iterable<StepDefinitionGeneric<World>> steps, {
    String featurePath = 'features/*.*.feature',
    String targetAppPath = 'test_driver/app.dart',
    String? targetAppWorkingDirectory,
    bool restartAppBetweenScenarios = true,
  }) {
    return FlutterDriverTestConfiguration(
      features: [RegExp(featurePath)],
      reporters: [
        StdoutReporter(MessageLevel.error),
        ProgressReporter(),
        TestRunSummaryReporter(),
        JsonReporter(path: './report.json'),
        FlutterDriverReporter(
          logErrorMessages: true,
          logInfoMessages: false,
          logWarningMessages: false,
        ),
      ],
      targetAppPath: targetAppPath,
      targetAppWorkingDirectory: targetAppWorkingDirectory,
      stepDefinitions: steps,
      restartAppBetweenScenarios: restartAppBetweenScenarios,
    );
  }

  /// restarts the application under test between each scenario.
  /// Defaults to true to avoid the application being in an invalid state
  /// before each test
  final bool restartAppBetweenScenarios;

  /// The target app to run the tests against
  /// Defaults to "test_driver/app.dart"
  final String targetAppPath;

  /// Option to define the working directory for the process that runs the app under test (optional)
  /// Handy if your app is separated from your tests as flutter needs to be able to find a pubspec file
  final String? targetAppWorkingDirectory;

  /// The build flavour to run the tests against (optional)
  /// Defaults to null
  final String? buildFlavour;

  /// The default build mode used for running tests is --debug.
  /// We are exposing the option to run the tests also in --profile mode
  final BuildMode buildMode;

  /// If the application should be built prior to running the tests
  /// Defaults to true
  final bool build;

  /// The target device id to run the tests against when multiple devices detected
  /// Defaults to null
  final String? targetDeviceId;

  /// Will keep the Flutter application running when done testing
  /// Defaults to false
  final bool keepAppRunningAfterTests;

  /// Logs Flutter process output to stdout
  /// The Flutter process is use to start and driver the app under test.
  /// The output may contain build and run information
  /// Defaults to false
  final bool logFlutterProcessOutput;

  /// Sets the --verbose flag on the flutter process
  /// Defaults to false
  final bool verboseFlutterProcessLogs;

  /// Duration to wait for Flutter to build and start the app on the target device
  /// Slower machine may take longer to build and run a large app
  /// Defaults to 90 seconds
  final Duration flutterBuildTimeout;

  /// Duration to wait before reconnecting the Flutter driver to the app.
  /// On slower machines the app might not be in a state where the driver can successfully connect immediately
  /// Defaults to 2 seconds
  final Duration flutterDriverReconnectionDelay;

  /// The maximum times the flutter driver can try and connect to the running app
  /// Defaults to 3
  final int flutterDriverMaxConnectionAttempts;

  /// An observatory url that the test runner can connect to instead of creating a new running instance of the target application
  /// Url takes the form of `http://127.0.0.1:51540/EM72VtRsUV0=/` and usually printed to stdout in the form `Connecting to service protocol: http://127.0.0.1:51540/EM72VtRsUV0=/`
  /// You will have to add the `--verbose` flag to the command to start your flutter app to see this output and ensure `enableFlutterDriverExtension()` is called by the running app
  final String? runningAppProtocolEndpointUri;

  /// Called before any attempt to connect Flutter driver to the running application,  Depending on your configuration this
  /// method will be called before each scenario is run.
  final Future<void> Function()? onBeforeFlutterDriverConnect;

  /// Called after the successful connection of Flutter driver to the running application.  Depending on your configuration this
  /// method will be called on each new connection usually before each scenario is run.
  final Future<void> Function(FlutterDriver driver)?
      onAfterFlutterDriverConnect;

  void setObservatoryDebuggerUri(String uri) => _observatoryDebuggerUri = uri;

  Future<FlutterDriver> createFlutterDriver([String? dartVmServiceUrl]) async {
    final completer = Completer<FlutterDriver>();
    dartVmServiceUrl = (dartVmServiceUrl ?? _observatoryDebuggerUri) ??
        Platform.environment['VM_SERVICE_URL'];

    await runZonedGuarded(
      () async {
        if (onBeforeFlutterDriverConnect != null) {
          await onBeforeFlutterDriverConnect!();
        }

        final driver = await _attemptDriverConnection(dartVmServiceUrl, 1, 3);
        if (onAfterFlutterDriverConnect != null) {
          await onAfterFlutterDriverConnect!(driver);
        }

        completer.complete(driver);
      },
      (Object e, StackTrace st) {
        if (e is DriverError) {
          completer.completeError(e, st);
        }
      },
    );

    return completer.future;
  }

  Future<FlutterWorld> createFlutterWorld(
    TestConfiguration config,
    FlutterWorld? world,
  ) async {
    var flutterConfig = config as FlutterDriverTestConfiguration;
    world = world ?? FlutterDriverWorld();

    final driver = await createFlutterDriver(
      flutterConfig.runningAppProtocolEndpointUri?.isNotEmpty ?? false
          ? flutterConfig.runningAppProtocolEndpointUri
          : null,
    );

    (world as FlutterDriverWorld).setFlutterDriver(driver);

    return world;
  }

  @override
  TestConfiguration prepare() {
    super.prepare();
    _ensureCorrectConfiguration();
    final providedCreateWorld = createWorld;

    return FlutterDriverTestConfiguration(
      buildFlavour: buildFlavour,
      customStepParameterDefinitions: customStepParameterDefinitions,
      defaultTimeout: defaultTimeout,
      featureDefaultLanguage: featureDefaultLanguage,
      featureFileMatcher: featureFileMatcher,
      featureFileReader: featureFileReader,
      features: features,
      onAfterFlutterDriverConnect: onAfterFlutterDriverConnect,
      onBeforeFlutterDriverConnect: onBeforeFlutterDriverConnect,
      order: order,
      reporters: reporters,
      restartAppBetweenScenarios: restartAppBetweenScenarios,
      runningAppProtocolEndpointUri: runningAppProtocolEndpointUri,
      stepDefinitions: stepDefinitions,
      stopAfterTestFailed: stopAfterTestFailed,
      tagExpression: tagExpression,
      targetAppPath: targetAppPath,
      targetAppWorkingDirectory: targetAppWorkingDirectory,
      targetDeviceId: targetDeviceId,
      createWorld: (config) async {
        FlutterWorld? world;
        if (providedCreateWorld != null) {
          world = await providedCreateWorld(config) as FlutterWorld;
        }

        return await createFlutterWorld(config, world);
      },
      hooks: List.from(hooks ?? const Iterable.empty())
        ..add(
          FlutterAppRunnerHook(),
        ),
    );
  }

  Future<FlutterDriver> _attemptDriverConnection(
    String? dartVmServiceUrl,
    int attempt,
    int maxAttempts,
  ) async {
    return await FlutterDriver.connect(
      dartVmServiceUrl: dartVmServiceUrl,
    ).catchError(
      (e, st) async {
        if (attempt > maxAttempts) {
          throw e;
        } else {
          // ignore: avoid_print
          print(
            'Flutter driver error connecting to application at `$dartVmServiceUrl`,'
            'retrying after delay of $flutterDriverReconnectionDelay',
          );
          await Future<void>.delayed(flutterDriverReconnectionDelay);

          return _attemptDriverConnection(
            dartVmServiceUrl,
            attempt + 1,
            maxAttempts,
          );
        }
      },
    );
  }

  void _ensureCorrectConfiguration() {
    if (runningAppProtocolEndpointUri?.isNotEmpty ?? false) {
      if (restartAppBetweenScenarios) {
        throw AssertionError(
          'Cannot restart app between scenarios if using runningAppProtocolEndpointUri',
        );
      }

      if (targetDeviceId?.isNotEmpty ?? false) {
        throw AssertionError(
          'Cannot target specific device id if using runningAppProtocolEndpointUri',
        );
      }
    }
  }
}
