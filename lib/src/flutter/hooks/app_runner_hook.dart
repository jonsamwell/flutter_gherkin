import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter_gherkin/src/flutter/configuration/flutter_driver_test_configuration.dart';
import 'package:flutter_gherkin/src/flutter/runners/flutter_run_process_handler.dart';
import 'package:flutter_gherkin/src/flutter/world/flutter_driver_world.dart';
import 'package:gherkin/gherkin.dart';

/// A hook that manages running the target flutter application
/// that is under test
class FlutterAppRunnerHook extends Hook {
  FlutterRunProcessHandler? _flutterRunProcessHandler;
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
    TestConfiguration config,
    String scenario,
    Iterable<Tag> tags,
  ) async {
    final flutterConfig = _castConfig(config);
    if (_flutterRunProcessHandler == null) {
      await _runApp(flutterConfig);
    }
  }

  @override
  Future<void> onAfterScenario(
    TestConfiguration config,
    String scenario,
    Iterable<Tag> tags, {
    bool? passed,
  }) async {
    final flutterConfig = _castConfig(config);
    haveRunFirstScenario = true;
    if (_flutterRunProcessHandler != null &&
        flutterConfig.restartAppBetweenScenarios) {
      await _restartApp();
    }
  }

  @override
  Future<void> onAfterScenarioWorldCreated(
    World world,
    String scenario,
    Iterable<Tag> tags,
  ) async {
    if (world is FlutterDriverWorld) {
      world.setFlutterProcessHandler(_flutterRunProcessHandler!);
    }
  }

  Future<void> _runApp(FlutterDriverTestConfiguration config) async {
    if (config.runningAppProtocolEndpointUri?.isNotEmpty ?? false) {
      stdout.writeln(
        "Connecting to running Flutter app under test at '${config.runningAppProtocolEndpointUri}', "
        'this might take a few moments',
      );
      config.setObservatoryDebuggerUri(config.runningAppProtocolEndpointUri!);
    } else {
      _flutterRunProcessHandler = FlutterRunProcessHandler()
        ..setLogFlutterProcessOutput(config.logFlutterProcessOutput)
        ..setVerboseFlutterLogs(config.verboseFlutterProcessLogs)
        ..setApplicationTargetFile(config.targetAppPath)
        ..setDriverConnectionDelay(config.flutterDriverReconnectionDelay)
        ..setWorkingDirectory(config.targetAppWorkingDirectory)
        ..setBuildRequired(haveRunFirstScenario ? false : config.build)
        ..setKeepAppRunning(config.keepAppRunningAfterTests)
        ..setBuildFlavor(config.buildFlavor)
        ..setBuildMode(config.buildMode)
        ..setDeviceTargetId(config.targetDeviceId);

      stdout.writeln(
          "Starting Flutter app under test '${config.targetAppPath}', this might take a few moments");
      await _flutterRunProcessHandler!.run();
      final observatoryUri = await _flutterRunProcessHandler!
          .waitForObservatoryDebuggerUri(config.flutterBuildTimeout);
      config.setObservatoryDebuggerUri(observatoryUri);
    }
  }

  Future<void> _terminateApp() async {
    if (_flutterRunProcessHandler != null) {
      stdout.writeln('Terminating Flutter app under test');
      await _flutterRunProcessHandler!.terminate();
      _flutterRunProcessHandler = null;
    }
  }

  Future<void> _restartApp() async {
    if (_flutterRunProcessHandler != null) {
      stdout.writeln('Restarting Flutter app under test');
      await _flutterRunProcessHandler!.restart();
    }
  }

  FlutterDriverTestConfiguration _castConfig(TestConfiguration config) =>
      config as FlutterDriverTestConfiguration;
}
