import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gherkin/gherkin.dart';

class FlutterRunProcessHandler extends ProcessHandler {
  static const String FAIL_COLOR = "\u001b[33;31m"; // red
  static const String WARN_COLOR = "\u001b[33;10m"; // yellow
  static const String RESET_COLOR = "\u001b[33;0m";

  static RegExp _observatoryDebuggerUriRegex = RegExp(
      r"observatory debugger .*[:]? (http[s]?:.*\/).*",
      caseSensitive: false,
      multiLine: false);

  static RegExp _noConnectedDeviceRegex =
      RegExp(r"no connected device", caseSensitive: false, multiLine: false);

  static RegExp _restartedApplicationSuccessRegex = RegExp(
      r"Restarted application (.*)ms.",
      caseSensitive: false,
      multiLine: false);

  Process _runningProcess;
  Stream<String> _processStdoutStream;
  List<StreamSubscription> _openSubscriptions = <StreamSubscription>[];
  bool _buildApp = true;
  String _workingDirectory;
  String _appTarget;
  String _buildFlavor;
  String _deviceTargetId;
  String currentObservatoryUri;

  void setApplicationTargetFile(String targetPath) {
    _appTarget = targetPath;
  }

  void setWorkingDirectory(String workingDirectory) {
    _workingDirectory = workingDirectory;
  }

  void setBuildFlavor(String buildFlavor) {
    _buildFlavor = buildFlavor;
  }

  void setDeviceTargetId(String deviceTargetId) {
    _deviceTargetId = deviceTargetId;
  }

  void setBuildRequired(bool build) {
    _buildApp = build;
  }

  @override
  Future<void> run() async {
    final arguments = ["run", "--target=$_appTarget"];

    if (_buildApp == false) {
      arguments.add("--no-build");
    }

    if (_buildFlavor.isNotEmpty) {
      arguments.add("--flavor=$_buildFlavor");
    }

    if (_deviceTargetId.isNotEmpty) {
      arguments.add("--device-id=$_deviceTargetId");
    }

    _runningProcess = await Process.start("flutter", arguments,
        workingDirectory: _workingDirectory, runInShell: true);
    _processStdoutStream =
        _runningProcess.stdout.transform(utf8.decoder).asBroadcastStream();

    _openSubscriptions.add(_runningProcess.stderr.listen((events) {
      final line = String.fromCharCodes(events).trim();
      if (line.startsWith('Note:')) {
        // This is most likely a depricated api usage warnings (from Gradle) and should not
        // cause the test run to fail.
        stdout
            .writeln("${WARN_COLOR}Flutter build warning: ${line}$RESET_COLOR");
      } else {
        stderr.writeln("${FAIL_COLOR}Flutter build error: ${line}$RESET_COLOR");
      }
    }));
  }

  @override
  Future<int> terminate() async {
    int exitCode = -1;
    _ensureRunningProcess();
    if (_runningProcess != null) {
      _runningProcess.stdin.write("q");
      _openSubscriptions.forEach((s) => s.cancel());
      _openSubscriptions.clear();
      exitCode = await _runningProcess.exitCode;
      _runningProcess = null;
    }

    return exitCode;
  }

  Future<bool> restart({Duration timeout = const Duration(seconds: 90)}) async {
    _ensureRunningProcess();
    _runningProcess.stdin.write("R");
    await _waitForStdOutMessage(
      _restartedApplicationSuccessRegex,
      "Timeout waiting for app restart",
      timeout,
    );

    // it seems we need a small delay here otherwise the flutter driver fails to
    // consistently connect
    await Future.delayed(Duration(seconds: 1));

    return Future.value(true);
  }

  Future<String> waitForObservatoryDebuggerUri() async {
    currentObservatoryUri = await _waitForStdOutMessage(
        _observatoryDebuggerUriRegex,
        "Timeout while waiting for observatory debugger uri");

    return currentObservatoryUri;
  }

  Future<String> _waitForStdOutMessage(RegExp matcher, String timeoutMessage,
      [Duration timeout = const Duration(seconds: 90)]) {
    _ensureRunningProcess();
    final completer = Completer<String>();
    StreamSubscription sub;
    sub = _processStdoutStream.timeout(timeout, onTimeout: (_) {
      sub?.cancel();
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException(timeoutMessage, timeout));
      }
    }).listen((logLine) {
      // uncomment for debug output
      // stdout.write(logLine);
      if (matcher.hasMatch(logLine)) {
        sub?.cancel();
        if (!completer.isCompleted) {
          completer.complete(matcher.firstMatch(logLine).group(1));
        }
      } else if (_noConnectedDeviceRegex.hasMatch(logLine)) {
        sub?.cancel();
        if (!completer.isCompleted) {
          stderr.writeln(
              "${FAIL_COLOR}No connected devices found to run app on and tests against$RESET_COLOR");
        }
      }
    }, cancelOnError: true);

    return completer.future;
  }

  void _ensureRunningProcess() {
    if (_runningProcess == null) {
      throw Exception(
          "FlutterRunProcessHandler: flutter run process is not active");
    }
  }
}
