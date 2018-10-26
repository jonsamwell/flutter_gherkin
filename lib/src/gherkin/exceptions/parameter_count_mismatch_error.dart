class GherkinStepParameterMismatchException implements Exception {
  final int expectParameterCount;
  final int actualParameterCount;
  final Type step;
  final String message;

  GherkinStepParameterMismatchException(
      this.step, this.expectParameterCount, this.actualParameterCount)
      : message = "$step parameter count mismatch. Expect $expectParameterCount parameters but got $actualParameterCount. " +
            "Ensure you are extending the correct step class which would be " +
            "Given${actualParameterCount > 0 ? '$actualParameterCount<${List.generate(actualParameterCount, (i) => "TInputType$i").join(", ")}>' : ''}";

  String toString() => message;
}
