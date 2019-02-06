import 'package:flutter_gherkin/flutter_gherkin.dart';

typedef void OnStepFinished(StepFinishedMessage message);

class ReporterMock extends Reporter {
  int onTestRunStartedInvocationCount = 0;
  int onTestRunfinishedInvocationCount = 0;
  int onFeatureStartedInvocationCount = 0;
  int onFeatureFinishedInvocationCount = 0;
  int onScenarioStartedInvocationCount = 0;
  int onScenarioFinishedInvocationCount = 0;
  int onStepStartedInvocationCount = 0;
  int onStepFinishedInvocationCount = 0;
  int onExceptionInvocationCount = 0;
  int messageInvocationCount = 0;
  int disposeInvocationCount = 0;

  OnStepFinished onStepFinishedFn;

  @override
  Future<void> onTestRunStarted() async => onTestRunStartedInvocationCount += 1;
  @override
  Future<void> onTestRunFinished() async =>
      onTestRunfinishedInvocationCount += 1;
  @override
  Future<void> onFeatureStarted(StartedMessage message) async =>
      onFeatureStartedInvocationCount += 1;
  @override
  Future<void> onFeatureFinished(FinishedMessage message) async =>
      onFeatureFinishedInvocationCount += 1;
  @override
  Future<void> onScenarioStarted(StartedMessage message) async =>
      onScenarioStartedInvocationCount += 1;
  @override
  Future<void> onScenarioFinished(FinishedMessage message) async =>
      onScenarioFinishedInvocationCount += 1;
  @override
  Future<void> onStepStarted(StartedMessage message) async =>
      onStepStartedInvocationCount += 1;
  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    if (onStepFinishedFn != null) onStepFinishedFn(message);
    onStepFinishedInvocationCount += 1;
  }

  @override
  Future<void> onException(Exception exception, StackTrace stackTrace) async =>
      onExceptionInvocationCount += 1;
  @override
  Future<void> message(String message, MessageLevel level) async =>
      messageInvocationCount += 1;
  @override
  Future<void> dispose() async => disposeInvocationCount += 1;
}
