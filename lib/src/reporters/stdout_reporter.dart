import 'dart:io';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/reporter.dart';

class StdoutReporter extends Reporter {
  final MessageLevel _logLevel;
  static const String NEUTRAL_COLOR = "\u001b[33;34m"; // blue
  static const String DEBUG_COLOR = "\u001b[1;30m"; // gray
  static const String FAIL_COLOR = "\u001b[33;31m"; // red
  static const String WARN_COLOR = "\u001b[33;10m"; // yellow
  static const String RESET_COLOR = "\u001b[33;0m";
  static const String PASS_COLOR = "\u001b[33;32m"; // green

  StdoutReporter([this._logLevel = MessageLevel.verbose]);

  Future<void> message(String message, MessageLevel level) async {
    if (level.index >= _logLevel.index) {
      printMessageLine(message, getColour(level));
    }
  }

  String getColour(MessageLevel level) {
    switch (level) {
      case MessageLevel.verbose:
      case MessageLevel.debug:
        return DEBUG_COLOR;
      case MessageLevel.error:
        return FAIL_COLOR;
      case MessageLevel.warning:
        return WARN_COLOR;
      case MessageLevel.info:
      default:
        return NEUTRAL_COLOR;
    }
  }

  void printMessageLine(String message, [String colour]) {
    stdout.writeln(
        "${colour == null ? RESET_COLOR : colour}$message$RESET_COLOR");
  }

  void printMessage(String message, [String colour]) {
    stdout
        .write("${colour == null ? RESET_COLOR : colour}$message$RESET_COLOR");
  }
}
