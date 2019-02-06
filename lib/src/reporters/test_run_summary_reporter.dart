import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/messages.dart';

class TestRunSummaryReporter extends StdoutReporter {
  final _timer = Stopwatch();
  final List<StepFinishedMessage> _ranSteps = <StepFinishedMessage>[];
  final List<ScenarioFinishedMessage> _ranScenarios =
      <ScenarioFinishedMessage>[];

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {
    _ranScenarios.add(message);
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    _ranSteps.add(message);
  }

  @override
  Future<void> message(String message, MessageLevel level) async {
    // ignore messages
  }

  @override
  Future<void> onTestRunStarted() async {
    _timer.start();
  }

  @override
  Future<void> onTestRunFinished() async {
    _timer.stop();
    printMessageLine(
        "${_ranScenarios.length} scenario${_ranScenarios.length > 1 ? "s" : ""} (${_collectScenarioSummary(_ranScenarios)})");
    printMessageLine(
        "${_ranSteps.length} step${_ranSteps.length > 1 ? "s" : ""} (${_collectStepSummary(_ranSteps)})");
    printMessageLine("${Duration(milliseconds: _timer.elapsedMilliseconds)}");
  }

  @override
  Future<void> dispose() async {
    if (_timer.isRunning) {
      _timer.stop();
    }
  }

  String _collectScenarioSummary(Iterable<ScenarioFinishedMessage> scenarios) {
    final List<String> summaries = <String>[];
    if (scenarios.any((s) => s.passed)) {
      summaries.add(
          "${StdoutReporter.PASS_COLOR}${scenarios.where((s) => s.passed).length} passed${StdoutReporter.RESET_COLOR}");
    }

    if (scenarios.any((s) => !s.passed)) {
      summaries.add(
          "${StdoutReporter.FAIL_COLOR}${scenarios.where((s) => !s.passed).length} failed${StdoutReporter.RESET_COLOR}");
    }

    return summaries.join(", ");
  }

  String _collectStepSummary(Iterable<StepFinishedMessage> steps) {
    final List<String> summaries = <String>[];
    final passed =
        steps.where((s) => s.result.result == StepExecutionResult.pass);
    final skipped =
        steps.where((s) => s.result.result == StepExecutionResult.skipped);
    final failed = steps.where((s) =>
        s.result.result == StepExecutionResult.error ||
        s.result.result == StepExecutionResult.fail ||
        s.result.result == StepExecutionResult.timeout);
    if (passed.isNotEmpty) {
      summaries.add(
          "${StdoutReporter.PASS_COLOR}${passed.length} passed${StdoutReporter.RESET_COLOR}");
    }

    if (skipped.isNotEmpty) {
      summaries.add(
          "${StdoutReporter.WARN_COLOR}${skipped.length} skipped${StdoutReporter.RESET_COLOR}");
    }

    if (failed.isNotEmpty) {
      summaries.add(
          "${StdoutReporter.FAIL_COLOR}${failed.length} failed${StdoutReporter.RESET_COLOR}");
    }

    return summaries.join(", ");
  }
}
