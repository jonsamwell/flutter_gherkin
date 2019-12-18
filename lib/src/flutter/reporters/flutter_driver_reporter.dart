import 'dart:async';
import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

/// The Flutter driver helpfully logs ALL messages to the stderr output
/// useless something is listening to the messages.
/// This reporter listens to the messages from the driver so nothing is logged
/// to the stderr stream unless it is actually an error.
/// This can cause problems with CI servers for example as they will mark a process as failed if it logs to the
/// stderr stream.  So Flutter driver will log a normal info message to the stderr and thus make
/// the process fail from the perspective of a CI server.
class FlutterDriverReporter extends Reporter {
  final bool logErrorMessages;
  final bool logWarningMessages;
  final bool logInfoMessages;
  final List<StreamSubscription> subscriptions = List<StreamSubscription>();

  FlutterDriverReporter({
    this.logErrorMessages = true,
    this.logWarningMessages = true,
    this.logInfoMessages = false,
  });

  Future<void> onTestRunStarted() async {
    if (logInfoMessages) {
      subscriptions.add(flutterDriverLog
          .where((log) => _isLevel(log.level, [LogLevel.info, LogLevel.trace]))
          .listen((log) {
        stdout.writeln(log.toString());
      }));
    }

    if (logWarningMessages) {
      subscriptions.add(flutterDriverLog
          .where((log) => _isLevel(log.level, [LogLevel.warning]))
          .listen((log) {
        stdout.writeln(log.toString());
      }));
    }

    if (logErrorMessages) {
      subscriptions.add(flutterDriverLog
          .where(
              (log) => _isLevel(log.level, [LogLevel.critical, LogLevel.error]))
          .listen((log) {
        stderr.writeln(log.toString());
      }));
    }
  }

  Future<void> dispose() async {
    subscriptions.forEach((s) => s.cancel());
    subscriptions.clear();
  }

  bool _isLevel(LogLevel level, Iterable<LogLevel> levels) =>
      levels.contains(level);
}