import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_gherkin/src/processes/process_handler.dart';

class FlutterRunProcessHandler extends ProcessHandler {
  static const String FAIL_COLOR = "\u001b[33;31m"; // red
  static const String RESET_COLOR = "\u001b[33;0m";

  static RegExp _observatoryDebuggerUriRegex = RegExp(
      r"observatory debugger .*[:]? (http[s]?:.*\/).*",
      caseSensitive: false,
      multiLine: false);
  Process _runningProcess;
  Stream<String> _processStdoutStream;
  List<StreamSubscription> _openSubscriptions = List<StreamSubscription>();
  String _appTarget;
  String _workingDirectory;

  void setApplicationTargetFile(String targetPath) {
    _appTarget = targetPath;
  }

  void setWorkingDirectory(String workingDirectory) {
    _workingDirectory = workingDirectory;
  }

  @override
  Future<void> run() async {
    _runningProcess = await Process.start(
        "flutter", ["run", "--target=$_appTarget"],
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
    sub = _processStdoutStream
        .timeout(timeout,
            onTimeout: (_) => completer.completeError(TimeoutException(
                "Time out while wait for observatory debugger uri", timeout)))
        .listen((logLine) {
      if (_observatoryDebuggerUriRegex.hasMatch(logLine)) {
        sub?.cancel();
        completer.complete(
            _observatoryDebuggerUriRegex.firstMatch(logLine).group(1));
      }
    });

    return completer.future;
  }

  void _ensureRunningProcess() {
    if (_runningProcess == null) {
      throw new Exception(
          "FlutterRunProcessHandler: flutter run process is not active");
    }
  }
}
