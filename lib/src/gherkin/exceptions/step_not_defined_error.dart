class GherkinStepNotDefinedException implements Exception {
  final String message;

  GherkinStepNotDefinedException(this.message);
}
