import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/messages.dart';

class ProgressReporter extends StdoutReporter {
  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    printMessageLine(
        "Running scenario: ${_getNameAndContext(message.name, message.context)}",
        StdoutReporter.WARN_COLOR);
  }

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {
    printMessageLine(
        "${message.passed ? 'PASSED' : 'FAILED'}: Scenario ${_getNameAndContext(message.name, message.context)}",
        message.passed ? StdoutReporter.PASS_COLOR : StdoutReporter.FAIL_COLOR);
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    printMessageLine(
        [
          "  ",
          _getStatePrefixIcon(message.result.result),
          _getNameAndContext(message.name, message.context),
          _getExecutionDuration(message.result),
          _getReasonMessage(message.result),
          _getErrorMessage(message.result)
        ].join((" ")).trimRight(),
        _getMessageColour(message.result.result));
  }

  @override
  Future<void> message(String message, MessageLevel level) async {
    // ignore messages
  }

  String _getReasonMessage(StepResult stepResult) {
    if (stepResult.resultReason != null && stepResult.resultReason.isNotEmpty) {
      return "\n      ${stepResult.resultReason}";
    } else {
      return "";
    }
  }

  String _getErrorMessage(StepResult stepResult) {
    if (stepResult is ErroredStepResult) {
      return "\n${stepResult.exception}\n${stepResult.stackTrace}";
    } else {
      return "";
    }
  }

  String _getNameAndContext(String name, RunnableDebugInformation context) {
    return "$name # ${context.filePath.replaceAll(RegExp(r"\.\\"), "")}:${context.lineNumber}";
  }

  String _getExecutionDuration(StepResult stepResult) {
    return "took ${stepResult.elapsedMilliseconds}ms";
  }

  String _getStatePrefixIcon(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.pass:
        return "√";
      case StepExecutionResult.error:
      case StepExecutionResult.fail:
      case StepExecutionResult.timeout:
        return "×";
      case StepExecutionResult.skipped:
        return "-";
    }

    return "";
  }

  String _getMessageColour(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.pass:
        return StdoutReporter.PASS_COLOR;
      case StepExecutionResult.fail:
        return StdoutReporter.FAIL_COLOR;
      case StepExecutionResult.error:
        return StdoutReporter.FAIL_COLOR;
      case StepExecutionResult.skipped:
        return StdoutReporter.WARN_COLOR;
      case StepExecutionResult.timeout:
        return StdoutReporter.FAIL_COLOR;
    }

    return StdoutReporter.RESET_COLOR;
  }
}
