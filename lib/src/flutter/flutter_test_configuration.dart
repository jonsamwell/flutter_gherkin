import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_gherkin/src/flutter/steps/given_i_open_the_drawer_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/restart_app_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_element_to_have_value_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_fill_field_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_pause_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_widget_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_the_back_button_step.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class FlutterTestConfiguration extends TestConfiguration {
  String _observatoryDebuggerUri;

  /// restarts the application under test between each scenario.
  /// Defaults to true to avoid the application being in an invalid state
  /// before each test
  bool restartAppBetweenScenarios = true;

  /// The target app to run the tests against
  /// Defaults to "lib/test_driver/app.dart"
  String targetAppPath = "lib/test_driver/app.dart";

  /// Option to define the working directory for the process that runs the app under test (optional)
  /// Handy if your app is seperated from your tests as flutter needs to be able to find a pubspec file
  String targetAppWorkingDirecotry;

  /// The build flavor to run the tests against (optional)
  /// Defaults to empty
  String buildFlavor = "";

  /// If the application should be built prior to running the tests
  /// Defaults to true
  bool build = true;

  /// The target device id to run the tests against when multiple devices detected
  /// Defaults to empty
  String targetDeviceId = "";

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
  int flutterDriverMaxConnectionAttemps = 3;

  void setObservatoryDebuggerUri(String uri) => _observatoryDebuggerUri = uri;

  Future<FlutterDriver> createFlutterDriver([String dartVmServiceUrl]) async {
    dartVmServiceUrl = (dartVmServiceUrl ?? _observatoryDebuggerUri) ??
        Platform.environment['VM_SERVICE_URL'];

    return await _attemptDriverConnection(dartVmServiceUrl, 1, 3);
  }

  Future<FlutterWorld> createFlutterWorld(
      TestConfiguration config, FlutterWorld world) async {
    world = world ?? FlutterWorld();
    final driver = await createFlutterDriver();
    world.setFlutterDriver(driver);
    return world;
  }

  @override
  void prepare() {
    final providedCreateWorld = createWorld;
    createWorld = (config) async {
      FlutterWorld world;
      if (providedCreateWorld != null) {
        world = await providedCreateWorld(config);
      }

      return await createFlutterWorld(config, world);
    };

    hooks = List.from(hooks ?? [])..add(FlutterAppRunnerHook());
    stepDefinitions = List.from(stepDefinitions ?? [])
      ..addAll([
        ThenExpectElementToHaveValue(),
        WhenTapWidget(),
        WhenTapBackButtonWidget(),
        GivenOpenDrawer(),
        WhenPauseStep(),
        WhenFillFieldStep(),
        RestartAppStep()
      ]);
  }

  Future<FlutterDriver> _attemptDriverConnection(
    String dartVmServiceUrl,
    int attempt,
    int maxAttemps,
  ) async {
    try {
      return await FlutterDriver.connect(
        dartVmServiceUrl: dartVmServiceUrl,
      );
    } catch (e) {
      if (attempt > maxAttemps) {
        rethrow;
      } else {
        print(e);
        await Future<void>.delayed(flutterDriverReconnectionDelay);

        return _attemptDriverConnection(
          dartVmServiceUrl,
          attempt + 1,
          maxAttemps,
        );
      }
    }
  }
}
