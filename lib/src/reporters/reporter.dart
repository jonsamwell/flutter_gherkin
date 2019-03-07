import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/messages.dart';

abstract class Reporter {
  Future<void> onTestRunStarted() async {}
  Future<void> onTestRunFinished() async {}
  Future<void> onFeatureStarted(StartedMessage message) async {}
  Future<void> onFeatureFinished(FinishedMessage message) async {}
  Future<void> onScenarioStarted(StartedMessage message) async {}
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {}
  Future<void> onStepStarted(StepStartedMessage message) async {}
  Future<void> onStepFinished(StepFinishedMessage message) async {}
  Future<void> onException(Exception exception, StackTrace stackTrace) async {}
  Future<void> message(String message, MessageLevel level) async {}
  Future<void> dispose() async {}
}
