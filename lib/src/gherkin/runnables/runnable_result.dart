enum RunnableResultState { ignored, skipped, failed, passed }

class RunnableResult {
  final RunnableResultState state;
  final dynamic result;
  final Exception error;

  RunnableResult(this.state, {this.result, this.error});
}
