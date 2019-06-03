import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gherkin/gherkin.dart';

class FlutterRunProcessHandler extends ProcessHandler {
  static const String FAIL_COLOR = "\u001b[33;31m"; // red
  static const String RESET_COLOR = "\u001b[33;0m";

  static RegExp _observatoryDebuggerUriRegex = RegExp(
      r"observatory debugger .*[:]? (http[s]?:.*\/).*",
      caseSensitive: false,
      multiLine: false);

  static RegExp _noConnectedDeviceRegex =
      RegExp(r"no connected device", caseSensitive: false, multiLine: false);
  Process _runningProcess;
  Stream<String> _processStdoutStream;
  List<StreamSubscription> _openSubscriptions = <StreamSubscription>[];
  String _appTarget;
  String _workingDirectory;
  String _buildFlavor;
  String _deviceTargetId;

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

  @override
  Future<void> run() async {
    final arguments = ["run", "--target=$_appTarget"];

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
      stderr.writeln(
          "${FAIL_COLOR}Flutter run error: ${String.fromCharCodes(events)}$RESET_COLOR");
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

  Future<String> waitForObservatoryDebuggerUri(
      [Duration timeout = const Duration(seconds: 60)]) {
    _ensureRunningProcess();
    final completer = Completer<String>();
    StreamSubscription sub;
    sub = _processStdoutStream.timeout(timeout, onTimeout: (_) {
      sub?.cancel();
      if (!completer.isCompleted)
        completer.completeError(TimeoutException(
            "Timeout while wait for observatory debugger uri", timeout));
    }).listen((logLine) {
      // stdout.write(logLine);
      if (_observatoryDebuggerUriRegex.hasMatch(logLine)) {
        sub?.cancel();
        if (!completer.isCompleted)
          completer.complete(
              _observatoryDebuggerUriRegex.firstMatch(logLine).group(1));
      } else if (_noConnectedDeviceRegex.hasMatch(logLine)) {
        sub?.cancel();
        if (!completer.isCompleted)
          stderr.writeln(
              "${FAIL_COLOR}No connected devices found to run app on and tests against$RESET_COLOR");
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
