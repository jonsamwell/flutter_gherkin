import 'dart:io';

import 'package:flutter_gherkin/src/configuration.dart';
import 'package:flutter_gherkin/src/flutter/flutter_run_process_handler.dart';
import 'package:flutter_gherkin/src/flutter/flutter_test_configuration.dart';
import 'package:flutter_gherkin/src/hooks/hook.dart';

/// A hook that manages running the arget flutter application
/// that is under test
class FlutterAppRunnerHook extends Hook {
  FlutterRunProcessHandler _flutterAppProcess;
  bool haveRunFirstScenario = false;

  @override
  int get priority => 999999;

  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    await _runApp(_castConfig(config));
  }

  @override
  Future<void> onAfterRun(TestConfiguration config) async =>
      await _terminateApp();

  @override
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario) async {
    final flutterConfig = _castConfig(config);
    if (_flutterAppProcess == null) {
      await _runApp(flutterConfig);
    }
  }

  @override
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario) async {
    final flutterConfig = _castConfig(config);
    haveRunFirstScenario = true;
    if (_flutterAppProcess != null &&
        flutterConfig.restartAppBetweenScenarios) {
      await _terminateApp();
    }
  }

  Future<void> _runApp(FlutterTestConfiguration config) async {
    _flutterAppProcess = FlutterRunProcessHandler();
    _flutterAppProcess.setApplicationTargetFile(config.targetAppPath);
    stdout.writeln(
        "Starting Flutter app under test '${config.targetAppPath}', this might take a few moments");
    await _flutterAppProcess.run();
    final observatoryUri =
        await _flutterAppProcess.waitForObservatoryDebuggerUri();
    config.setObservatoryDebuggerUri(observatoryUri);
  }

  Future<void> _terminateApp() async {
    if (_flutterAppProcess != null) {
      stdout.writeln("Terminating Flutter app under test");
      await _flutterAppProcess.terminate();
      _flutterAppProcess = null;
    }
  }

  FlutterTestConfiguration _castConfig(TestConfiguration config) =>
      config as FlutterTestConfiguration;
}
