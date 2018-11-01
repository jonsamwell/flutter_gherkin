import "package:flutter_gherkin/flutter_gherkin.dart";
import "package:flutter_gherkin/src/gherkin/runnables/debug_information.dart";
import "package:flutter_gherkin/src/gherkin/steps/step_run_result.dart";
import "package:test/test.dart";

class TestableProgressReporter extends ProgressReporter {
  final output = List<String>();
  @override
  void printMessageLine(String message, [String colour]) {
    output.add(message);
  }
}

void main() {
  group("report", () {
    test("provides correct step finished output", () async {
      final reporter = TestableProgressReporter();

      await reporter.onStepFinished(StepFinishedMessage(
          "Step 1",
          RunnableDebugInformation("filePath", 1, "line 1"),
          StepResult(0, StepExecutionResult.pass)));
      await reporter.onStepFinished(StepFinishedMessage(
          "Step 2",
          RunnableDebugInformation("filePath", 2, "line 2"),
          StepResult(0, StepExecutionResult.fail, "Failed Reason")));
      await reporter.onStepFinished(StepFinishedMessage(
          "Step 3",
          RunnableDebugInformation("filePath", 3, "line 3"),
          StepResult(0, StepExecutionResult.skipped)));
      await reporter.onStepFinished(StepFinishedMessage(
          "Step 4",
          RunnableDebugInformation("filePath", 4, "line 4"),
          StepResult(0, StepExecutionResult.error)));
      await reporter.onStepFinished(StepFinishedMessage(
          "Step 5",
          RunnableDebugInformation("filePath", 5, "line 5"),
          StepResult(1, StepExecutionResult.timeout)));

      expect(reporter.output, [
        "   √ Step 1 # filePath:1 took 0ms",
        "   × Step 2 # filePath:2 took 0ms \n"
            "      Failed Reason",
        "   - Step 3 # filePath:3 took 0ms",
        "   × Step 4 # filePath:4 took 0ms",
        "   × Step 5 # filePath:5 took 1ms"
      ]);
    });

    test("provides correct scenerio started output", () async {
      final reporter = TestableProgressReporter();

      await reporter.onScenarioStarted(StartedMessage(Target.scenario,
          "Scenerio 1", RunnableDebugInformation("filePath", 1, "line 1")));

      expect(reporter.output, ["Running scenario: Scenerio 1 # filePath:1"]);
    });
  });
}
