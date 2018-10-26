import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_gherkin/src/flutter/steps/given_i_open_the_drawer_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_element_to_have_value_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_widget_step.dart';
import 'package:flutter_driver/flutter_driver.dart';

class FlutterTestConfiguration extends TestConfiguration {
  String _observatoryDebuggerUri;

  /// restarts the application under test between each scenario.
  /// Defaults to true to avoid the application being in an invalid state
  /// before each test
  bool restartAppBetweenScenarios = true;

  /// The target app to run the tests against
  /// Defaults to "lib/app.dart"
  String targetAppPath = "lib/app.dart";

  FlutterTestConfiguration() : super() {
    createWorld = (config) async => await createFlutterWorld(config);
    stepDefinitions = [
      ThenExpectElementToHaveValue(),
      WhenTapWidget(),
      GivenOpenDrawer()
    ];
    hooks = [FlutterAppRunnerHook()];
  }

  void setObservatoryDebuggerUri(String uri) => _observatoryDebuggerUri = uri;

  Future<FlutterDriver> createFlutterDriver([String dartVmServiceUrl]) async {
    dartVmServiceUrl = (dartVmServiceUrl ?? _observatoryDebuggerUri) ??
        Platform.environment['VM_SERVICE_URL'];
    final driver = await FlutterDriver.connect(
        dartVmServiceUrl: dartVmServiceUrl,
        isolateReadyTimeout: Duration(seconds: 30));
    return driver;
  }

  Future<FlutterWorld> createFlutterWorld(TestConfiguration config) async {
    final world = new FlutterWorld();
    final driver = await createFlutterDriver();
    world.setFlutterDriver(driver);
    return world;
  }
}
