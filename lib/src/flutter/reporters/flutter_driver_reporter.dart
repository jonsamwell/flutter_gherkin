import 'dart:async';
import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

enum _FlutterDriverMessageLogLevel { info, warning, error }

/// The Flutter driver helpfully logs ALL messages to the stderr output
/// useless something is listening to the messages.
/// This reporter listens to the messages from the driver so nothing is logged
/// to the stderr stream unless it is actually an error.
/// This can cause problems with CI servers for example as they will mark a process as failed if it logs to the
/// stderr stream.  So Flutter driver will log a normal info message to the stderr and thus make
/// the process fail from the perspective of a CI server.
class FlutterDriverReporter extends Reporter
    implements DisposableReporter, TestReporter {
  final bool logErrorMessages;
  final bool logWarningMessages;
  final bool logInfoMessages;

  DriverLogCallback? defaultCallback;

  FlutterDriverReporter({
    this.logErrorMessages = true,
    this.logWarningMessages = true,
    this.logInfoMessages = false,
  });

  @override
  ReportActionHandler<TestMessage> get test => ReportActionHandler(
        onStarted: ([_]) async {
          defaultCallback = driverLog;
          driverLog = _driverLogMessageHandler;
        },
      );

  @override
  Future<void> dispose() async {
    if (defaultCallback != null) {
      driverLog = defaultCallback!;
    }
  }

  void _driverLogMessageHandler(String source, String message) {
    final level = _getMessageLevel(message);
    final log = '$source $message';

    if (logWarningMessages && level == _FlutterDriverMessageLogLevel.warning) {
      stdout.writeln(log);
    } else if (logErrorMessages &&
        level == _FlutterDriverMessageLogLevel.error) {
      stderr.writeln(log);
    } else {
      stdout.writeln(log);
    }
  }

  _FlutterDriverMessageLogLevel _getMessageLevel(String message) {
    if (message.toLowerCase().contains('warning')) {
      return _FlutterDriverMessageLogLevel.warning;
    } else if (message.toLowerCase().contains('error')) {
      return _FlutterDriverMessageLogLevel.error;
    } else {
      return _FlutterDriverMessageLogLevel.info;
    }
  }
}
