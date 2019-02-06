import 'dart:async';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/exceptions/parameter_count_mismatch_error.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_configuration.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:test/test.dart';

class StepDefinitionMock extends StepDefinitionGeneric<World> {
  int invocationCount = 0;
  final Func0<Future<void>> code;

  StepDefinitionMock(
      StepDefinitionConfiguration config, int expectParameterCount,
      [this.code])
      : super(config, expectParameterCount);

  @override
  Future<void> onRun(Iterable parameters) async {
    invocationCount += 1;
    if (code != null) {
      await code();
    }
  }

  @override
  RegExp get pattern => null;
}

void main() {
  group("onRun", () {
    group("parameter gaurd", () {
      test("throws exception when parameter counts mismatch", () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 2);
        expect(
            () async => await step.run(
                null, null, const Duration(seconds: 1), const Iterable.empty()),
            throwsA((e) =>
                e is GherkinStepParameterMismatchException &&
                e.message ==
                    "StepDefinitionMock parameter count mismatch. Expect 2 parameters but got 0. "
                    "Ensure you are extending the correct step class which would be Given"));
        expect(step.invocationCount, 0);
      });

      test(
          "throws exception when parameter counts mismatch listing required step type",
          () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 2);
        expect(
            () async =>
                await step.run(null, null, const Duration(seconds: 1), [1]),
            throwsA((e) =>
                e is GherkinStepParameterMismatchException &&
                e.message ==
                    "StepDefinitionMock parameter count mismatch. Expect 2 parameters but got 1. "
                    "Ensure you are extending the correct step class which would be Given1<TInputType0>"));
        expect(step.invocationCount, 0);
      });

      test("runs step when correct number of parameters provided", () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 1);
        await step.run(null, null, const Duration(seconds: 1), [1]);
        expect(step.invocationCount, 1);
      });
    });

    group("exception reported", () {
      test("when exception is throw in test it is report as an error",
          () async {
        final step = StepDefinitionMock(
            StepDefinitionConfiguration(), 0, () async => throw Exception("1"));
        expect(
            await step.run(null, null, const Duration(milliseconds: 1),
                const Iterable.empty()), (r) {
          return r is ErroredStepResult &&
              r.result == StepExecutionResult.error &&
              r.exception is Exception &&
              r.exception.toString() == "Exception: 1";
        });
      });
    });

    group("expectation failures reported", () {
      test("when an expectation fails the step is failed", () async {
        final step = StepDefinitionMock(StepDefinitionConfiguration(), 0,
            () async => throw TestFailure("1"));
        expect(
            await step.run(null, null, const Duration(milliseconds: 1),
                const Iterable.empty()), (r) {
          return r is StepResult &&
              r.result == StepExecutionResult.fail &&
              r.resultReason == "1";
        });
      });
    });
  });
}
