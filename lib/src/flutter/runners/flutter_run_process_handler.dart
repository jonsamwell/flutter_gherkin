import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_gherkin/src/flutter/configuration/build_mode.dart';
import 'package:gherkin/gherkin.dart';

class FlutterRunProcessHandler extends ProcessHandler {
  // the flutter process usually outputs something like the below to indicate the app is ready to be connected to
  // `An Observatory debugger and profiler on AOSP on IA Emulator is available at: http://127.0.0.1:51322/BI_fyYaeoCE=/`
  // `Observatory URL on device: http://127.0.0.1:37849/t2xp9hvaxNs=/`
  static final RegExp _observatoryDebuggerUriRegex = RegExp(
    r'observatory .*[:] (http[s]?:.*\/).*',
    caseSensitive: false,
    multiLine: false,
  );

  static final RegExp _noConnectedDeviceRegex = RegExp(
    r'no connected device|no supported devices connected',
    caseSensitive: false,
    multiLine: false,
  );

  static final RegExp _moreThanOneDeviceConnectedDeviceRegex = RegExp(
    r'more than one device connected',
    caseSensitive: false,
    multiLine: false,
  );

  static final RegExp _errorMessageRegex = RegExp(
    r'aborted|error|failure|unexpected|failed|exception',
    caseSensitive: false,
    multiLine: false,
  );

  static final RegExp _restartedApplicationSuccessRegex = RegExp(
    r'Restarted application (.*)ms.',
    caseSensitive: false,
    multiLine: false,
  );

  Process? _runningProcess;
  Stream<String>? _processStdoutStream;
  final List<StreamSubscription> _openSubscriptions = <StreamSubscription>[];
  bool _buildApp = true;
  bool _logFlutterProcessOutput = false;
  bool _verboseFlutterLogs = false;
  bool _keepAppRunning = false;
  BuildMode _buildMode = BuildMode.debug;
  String? _workingDirectory;
  String? _appTarget;
  String? _buildFlavour;
  String? _deviceTargetId;
  Duration _driverConnectionDelay = const Duration(seconds: 2);
  String? currentObservatoryUri;

  void setLogFlutterProcessOutput(bool logFlutterProcessOutput) {
    _logFlutterProcessOutput = logFlutterProcessOutput;
  }

  void setApplicationTargetFile(String targetPath) {
    _appTarget = targetPath;
  }

  void setDriverConnectionDelay(Duration? duration) {
    _driverConnectionDelay = duration ?? _driverConnectionDelay;
  }

  void setWorkingDirectory(String? workingDirectory) {
    _workingDirectory = workingDirectory;
  }

  void setBuildFlavour(String? buildFlavour) {
    _buildFlavour = buildFlavour;
  }

  void setBuildMode(BuildMode buildMode) {
    _buildMode = buildMode;
  }

  void setDeviceTargetId(String? deviceTargetId) {
    _deviceTargetId = deviceTargetId;
  }

  void setBuildRequired(bool build) {
    _buildApp = build;
  }

  void setVerboseFlutterLogs(bool verbose) {
    _verboseFlutterLogs = verbose;
  }

  void setKeepAppRunning(bool keepRunning) {
    _keepAppRunning = keepRunning;
  }

  @override
  Future<void> run() async {
    final arguments = ['run', '--target=$_appTarget'];

    if (_buildMode == BuildMode.debug) {
      arguments.add('--debug');
    } else if (_buildMode == BuildMode.profile) {
      arguments.add('--profile');
    }

    if (_buildApp == false) {
      arguments.add('--no-build');
    }

    if (_buildFlavour != null && _buildFlavour!.isNotEmpty) {
      arguments.add('--flavor=$_buildFlavour');
    }

    if (_deviceTargetId != null && _deviceTargetId!.isNotEmpty) {
      arguments.add('--device-id=$_deviceTargetId');
    }

    if (_verboseFlutterLogs) {
      arguments.add('--verbose');
    }

    if (_logFlutterProcessOutput) {
      stdout.writeln(
        'Invoking from working directory `${_workingDirectory ?? './'}` command: `flutter ${arguments.join(' ')}`',
      );
    }

    _runningProcess = await Process.start(
      'flutter',
      arguments,
      workingDirectory: _workingDirectory,
      runInShell: true,
    );

    _processStdoutStream =
        _runningProcess!.stdout.transform(utf8.decoder).asBroadcastStream();

    _openSubscriptions.add(_runningProcess!.stderr
        .map((events) => String.fromCharCodes(events).trim())
        .where((event) => event.isNotEmpty)
        .listen((event) {
      if (event.contains(_errorMessageRegex)) {
        stderr.writeln(
          '${StdoutReporter.kFailColor}Flutter build error: $event${StdoutReporter.kResetColor}',
        );
      } else {
        // This is most likely a deprecated api usage warnings (from Gradle) and should not
        // cause the test run to fail.
        stdout.writeln(
          '${StdoutReporter.kWarnColor}$event${StdoutReporter.kResetColor}',
        );
      }
    }));
  }

  @override
  Future<int> terminate() async {
    var exitCode = -1;
    _ensureRunningProcess();
    if (_runningProcess != null) {
      if (_keepAppRunning) {
        _runningProcess!.stdin.write('d');
      } else {
        _runningProcess!.stdin.write('q');
      }

      for (var s in _openSubscriptions) {
        s.cancel();
      }
      _openSubscriptions.clear();
      exitCode = await _runningProcess!.exitCode;
      _runningProcess = null;
    }

    return exitCode;
  }

  Future<bool> restart({
    Duration? timeout = const Duration(seconds: 90),
  }) async {
    _ensureRunningProcess();
    _runningProcess!.stdin.write('R');
    await _waitForStdOutMessage(
      _restartedApplicationSuccessRegex,
      'Timeout waiting for app restart',
      timeout,
    );

    // it seems we need a small delay here otherwise the flutter driver fails to
    // consistently connect
    await Future.delayed(_driverConnectionDelay);

    return Future.value(true);
  }

  Future<String> waitForObservatoryDebuggerUri([
    Duration timeout = const Duration(seconds: 90),
  ]) async {
    currentObservatoryUri = await _waitForStdOutMessage(
      _observatoryDebuggerUriRegex,
      'Timeout while waiting for observatory debugger uri',
      timeout,
    );

    return currentObservatoryUri!;
  }

  Future<String> _waitForStdOutMessage(
    RegExp matcher,
    String timeoutMessage, [
    Duration? timeout = const Duration(seconds: 90),
  ]) {
    _ensureRunningProcess();
    final completer = Completer<String>();
    StreamSubscription? sub;
    sub = _processStdoutStream!.timeout(
      timeout ?? const Duration(seconds: 90),
      onTimeout: (_) {
        sub?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException(timeoutMessage, timeout));
        }
      },
    ).listen(
      (logLine) {
        if (_logFlutterProcessOutput) {
          stdout.write(logLine);
        }
        if (matcher.hasMatch(logLine)) {
          sub?.cancel();
          if (!completer.isCompleted) {
            completer.complete(matcher.firstMatch(logLine)!.group(1));
          }
        } else if (_noConnectedDeviceRegex.hasMatch(logLine)) {
          sub?.cancel();
          if (!completer.isCompleted) {
            stderr.writeln(
              '${StdoutReporter.kFailColor}'
              'No connected devices found to run app on and tests against'
              '${StdoutReporter.kResetColor}',
            );
          }
        } else if (_moreThanOneDeviceConnectedDeviceRegex.hasMatch(logLine)) {
          sub?.cancel();
          if (!completer.isCompleted) {
            stderr.writeln(
              '${StdoutReporter.kFailColor}$logLine${StdoutReporter.kResetColor}',
            );
          }
        }
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  void _ensureRunningProcess() {
    if (_runningProcess == null) {
      throw Exception(
          'FlutterRunProcessHandler: flutter run process is not active');
    }
  }
}
