enum StepExecutionResult { pass, fail, skipped, timeout, error }

class StepResult {
  /// the duration in milliseconds the step took to run
  final int elapsedMilliseconds;

  /// the result of executing the step
  final StepExecutionResult result;
  // a reason for the result.  This would be a failure message if the result failed.  This field can be null
  final String resultReason;

  StepResult(this.elapsedMilliseconds, this.result, [this.resultReason]);
}

class ErroredStepResult extends StepResult {
  final Exception exception;
  final StackTrace stackTrace;

  ErroredStepResult(int elapsedMilliseconds, StepExecutionResult result,
      this.exception, this.stackTrace)
      : super(elapsedMilliseconds, result);
}
