import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:test/test.dart';

class TestableTestRunSummaryReporter extends TestRunSummaryReporter {
  final output = <String>[];
  @override
  void printMessageLine(String message, [String colour]) {
    output.add(message);
  }
}

void main() {
  group("report", () {
    test("provides correct output", () async {
      final reporter = TestableTestRunSummaryReporter();

      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.fail)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.skipped)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.skipped)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.error)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          "", null, StepResult(0, StepExecutionResult.timeout)));

      await reporter
          .onScenarioFinished(ScenarioFinishedMessage("", null, true));
      await reporter
          .onScenarioFinished(ScenarioFinishedMessage("", null, false));
      await reporter
          .onScenarioFinished(ScenarioFinishedMessage("", null, false));
      await reporter
          .onScenarioFinished(ScenarioFinishedMessage("", null, true));

      await reporter.onTestRunFinished();
      expect(reporter.output, [
        "4 scenarios (\x1B[33;32m2 passed\x1B[33;0m, \x1B[33;31m2 failed\x1B[33;0m)",
        "8 steps (\x1B[33;32m3 passed\x1B[33;0m, \x1B[33;10m2 skipped\x1B[33;0m, \x1B[33;31m3 failed\x1B[33;0m)",
        "0:00:00.000000"
      ]);
    });
  });
}
