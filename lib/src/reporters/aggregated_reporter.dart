import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/reporter.dart';

class AggregatedReporter extends Reporter {
  final List<Reporter> _reporters = new List<Reporter>();

  void addReporter(Reporter reporter) => _reporters.add(reporter);

  @override
  Future<void> message(String message, MessageLevel level) async {
    await _invokeReporters((r) async => await r.message(message, level));
  }

  @override
  Future<void> onTestRunStarted() async {
    await _invokeReporters((r) async => await r.onTestRunStarted());
  }

  @override
  Future<void> onTestRunFinished() async {
    await _invokeReporters((r) async => await r.onTestRunFinished());
  }

  @override
  Future<void> onFeatureStarted(StartedMessage message) async {
    await _invokeReporters((r) async => await r.onFeatureStarted(message));
  }

  @override
  Future<void> onFeatureFinished(FinishedMessage message) async {
    await _invokeReporters((r) async => await r.onFeatureFinished(message));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    await _invokeReporters((r) async => await r.onScenarioStarted(message));
  }

  @override
  Future<void> onScenarioFinished(FinishedMessage message) async {
    await _invokeReporters((r) async => await r.onScenarioFinished(message));
  }

  @override
  Future<void> onStepStarted(StartedMessage message) async {
    await _invokeReporters((r) async => await r.onStepStarted(message));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    await _invokeReporters((r) async => await r.onStepFinished(message));
  }

  @override
  Future<void> onException(Exception exception, StackTrace stackTrace) async {
    await _invokeReporters(
        (r) async => await r.onException(exception, stackTrace));
  }

  @override
  Future<void> dispose() async {
    await _invokeReporters((r) async => await r.dispose());
  }

  Future<void> _invokeReporters(Future<void> invoke(Reporter r)) async {
    if (_reporters != null && _reporters.length > 0) {
      for (var reporter in _reporters) {
        try {
          await invoke(reporter);
        } catch (e) {}
      }
    }
  }
}
