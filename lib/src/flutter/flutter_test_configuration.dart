import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/flutter/flutter_world.dart';
import 'package:flutter_gherkin/src/flutter/hooks/app_runner_hook.dart';
import 'package:flutter_gherkin/src/flutter/steps/given_i_open_the_drawer_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/then_expect_element_to_have_value_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_fill_field_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_pause_step.dart';
import 'package:flutter_gherkin/src/flutter/steps/when_tap_widget_step.dart';
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

  void setObservatoryDebuggerUri(String uri) => _observatoryDebuggerUri = uri;

  Future<FlutterDriver> createFlutterDriver([String dartVmServiceUrl]) async {
    dartVmServiceUrl = (dartVmServiceUrl ?? _observatoryDebuggerUri) ??
        Platform.environment['VM_SERVICE_URL'];
    final driver = await FlutterDriver.connect(
        dartVmServiceUrl: dartVmServiceUrl,
        logCommunicationToFile: false,
        printCommunication: false);
    return driver;
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
        GivenOpenDrawer(),
        WhenPauseStep(),
        WhenFillFieldStep()
      ]);
  }
}
