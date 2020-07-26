import 'dart:async';
import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_gherkin/src/flutter/parameters/existence_parameter.dart';
import 'package:flutter_gherkin/src/flutter/parameters/swipe_direction_parameter.dart';
import 'package:flutter_gherkin/src/flutter/steps/given_i_open_the_drawer_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/restart_app_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/sibling_contains_text_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/swipe_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_text_within_widget_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_widget_of_type_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_widget_of_type_within_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/tap_widget_with_text_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/text_exists_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/text_exists_within_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_element_to_have_value_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/wait_until_key_exists_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/wait_until_type_exists_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_fill_field_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_pause_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_widget_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_the_back_button_step.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/then_expect_widget_to_be_present_step.dart';

class FlutterTestConfiguration extends TestConfiguration {
  String _observatoryDebuggerUri;

  /// Provide a configuration object with default settings such as the reports and feature file location
  /// Additional setting on the configuration object can be set on the returned instance.
  static FlutterTestConfiguration DEFAULT(
    Iterable<StepDefinitionGeneric<World>> steps, {
    String featurePath = 'test_driver/features/**.feature',
    String targetAppPath = 'test_driver/app.dart',
  }) {
    return FlutterTestConfiguration()
      ..features = [Glob(featurePath)]
      ..reporters = [
        StdoutReporter(MessageLevel.error),
        ProgressReporter(),
        TestRunSummaryReporter(),
        JsonReporter(path: './report.json'),
        FlutterDriverReporter(
          logErrorMessages: true,
          logInfoMessages: false,
          logWarningMessages: false,
        ),
      ]
      ..targetAppPath = targetAppPath
      ..stepDefinitions = steps
      ..restartAppBetweenScenarios = true
      ..exitAfterTestRun = true;
  }

  /// restarts the application under test between each scenario.
  /// Defaults to true to avoid the application being in an invalid state
  /// before each test
  bool restartAppBetweenScenarios = true;

  /// The target app to run the tests against
  /// Defaults to "lib/test_driver/app.dart"
  String targetAppPath = 'lib/test_driver/app.dart';

  /// Option to define the working directory for the process that runs the app under test (optional)
  /// Handy if your app is separated from your tests as flutter needs to be able to find a pubspec file
  String targetAppWorkingDirectory;

  /// The build flavor to run the tests against (optional)
  /// Defaults to empty
  String buildFlavor = '';

  /// If the application should be built prior to running the tests
  /// Defaults to true
  bool build = true;

  /// The target device id to run the tests against when multiple devices detected
  /// Defaults to empty
  String targetDeviceId = '';

  /// Logs Flutter process output to stdout
  /// The Flutter process is use to start and driver the app under test.
  /// The output may contain build and run information
  /// Defaults to false
  bool logFlutterProcessOutput = false;

  /// Sets the --verbose flag on the flutter process
  /// Defaults to false
  bool verboseFlutterProcessLogs = false;

  /// Duration to wait for Flutter to build and start the app on the target device
  /// Slower machine may take longer to build and run a large app
  /// Defaults to 90 seconds
  Duration flutterBuildTimeout = const Duration(seconds: 90);

  /// Duration to wait before reconnecting the Flutter driver to the app.
  /// On slower machines the app might not be in a state where the driver can successfully connect immediately
  /// Defaults to 2 seconds
  Duration flutterDriverReconnectionDelay = const Duration(seconds: 2);

  /// The maximum times the flutter driver can try and connect to the running app
  /// Defaults to 3
  int flutterDriverMaxConnectionAttempts = 3;

  /// An observatory url that the test runner can connect to instead of creating a new running instance of the target application
  /// Url takes the form of `http://127.0.0.1:51540/EM72VtRsUV0=/` and usually printed to stdout in the form `Connecting to service protocol: http://127.0.0.1:51540/EM72VtRsUV0=/`
  /// You will have to add the `--verbose` flag to the command to start your flutter app to see this output and ensure `enableFlutterDriverExtension()` is called by the running app
  String runningAppProtocolEndpointUri;

  /// Called before any attempt to connect Flutter driver to the running application,  Depending on your configuration this
  /// method will be called before each scenario is run.
  Future<void> Function() onBeforeFlutterDriverConnect;

  /// Called after the successful connection of Flutter driver to the running application.  Depending on your configuration this
  /// method will be called on each new connection usually before each scenario is run.
  Future<void> Function(FlutterDriver driver) onAfterFlutterDriverConnect;

  void setObservatoryDebuggerUri(String uri) => _observatoryDebuggerUri = uri;

  Future<FlutterDriver> createFlutterDriver([String dartVmServiceUrl]) async {
    final completer = Completer<FlutterDriver>();
    dartVmServiceUrl = (dartVmServiceUrl ?? _observatoryDebuggerUri) ??
        Platform.environment['VM_SERVICE_URL'];

    await runZonedGuarded(
      () async {
        if (onBeforeFlutterDriverConnect != null) {
          await onBeforeFlutterDriverConnect();
        }

        final driver = await _attemptDriverConnection(dartVmServiceUrl, 1, 3);
        if (onAfterFlutterDriverConnect != null) {
          await onAfterFlutterDriverConnect(driver);
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
    FlutterWorld world,
  ) async {
    var flutterConfig = config as FlutterTestConfiguration;
    world = world ?? FlutterWorld();

    final driver = await createFlutterDriver(
      flutterConfig.runningAppProtocolEndpointUri != null &&
              flutterConfig.runningAppProtocolEndpointUri.isNotEmpty
          ? flutterConfig.runningAppProtocolEndpointUri
          : null,
    );

    world.setFlutterDriver(driver);

    return world;
  }

  @override
  void prepare() {
    _ensureCorrectConfiguration();
    final providedCreateWorld = createWorld;
    createWorld = (config) async {
      FlutterWorld world;
      if (providedCreateWorld != null) {
        world = await providedCreateWorld(config);
      }

      return await createFlutterWorld(config, world);
    };

    hooks = List.from(hooks ?? [])..add(FlutterAppRunnerHook());
    customStepParameterDefinitions =
        List.from(customStepParameterDefinitions ?? [])
          ..addAll([
            ExistenceParameter(),
            SwipeDirectionParameter(),
          ]);
    stepDefinitions = List.from(stepDefinitions ?? [])
      ..addAll([
        ThenExpectElementToHaveValue(),
        WhenTapBackButtonWidget(),
        WhenTapWidget(),
        WhenTapWidgetWithoutScroll(),
        GivenOpenDrawer(),
        WhenPauseStep(),
        WhenFillFieldStep(),
        ThenExpectWidgetToBePresent(),
        RestartAppStep(),
        SiblingContainsTextStep(),
        SwipeOnKeyStep(),
        SwipeOnTextStep(),
        TapTextWithinWidgetStep(),
        TapWidgetOfTypeStep(),
        TapWidgetOfTypeWithinStep(),
        TapWidgetWithTextStep(),
        TextExistsStep(),
        TextExistsWithinStep(),
        WaitUntilKeyExistsStep(),
        WaitUntilTypeExistsStep(),
      ]);
  }

  Future<FlutterDriver> _attemptDriverConnection(
    String dartVmServiceUrl,
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
          print(
            'Fluter driver error connecting to application at `$dartVmServiceUrl`, retrying after delay of $flutterDriverReconnectionDelay',
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
    if (runningAppProtocolEndpointUri != null &&
        runningAppProtocolEndpointUri.isNotEmpty) {
      if (restartAppBetweenScenarios) {
        throw AssertionError(
            'Cannot restart app between scenarios if using runningAppProtocolEndpointUri');
      }

      if (targetDeviceId != null && targetDeviceId.isNotEmpty) {
        throw AssertionError(
            'Cannot target specific device id if using runningAppProtocolEndpointUri');
      }
    }
  }
}
