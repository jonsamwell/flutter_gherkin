import 'dart:convert';
import 'dart:io';

import 'package:flutter_gherkin/flutter_gherkin.dart';

import 'json_feature.dart';
import 'json_scenario.dart';
import 'json_step.dart';

class JsonReporter extends Reporter {
  String path;
  List<JsonFeature> _features = [];

  JsonReporter({this.path = "./report.json"});

  @override
  Future<void> onFeatureStarted(StartedMessage message) async {
    _features.add(JsonFeature.from(message));
  }

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    _features.last.add(scenario: JsonScenario.from(message));
  }

  @override
  Future<void> onStepStarted(StepStartedMessage message) async {
    _features.last.currentScenario().add(step: JsonStep.from(message));
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    _features.last.currentScenario().currentStep().onFinish(message);
  }

  @override
  Future<void> onException(Exception exception, StackTrace stackTrace) async {
    _features.last.currentScenario().currentStep().onException(exception, stackTrace);
  }

  @override
  Future<void> onTestRunFinished() async {
    await generateReport(path, _features);
  }

  Future<void> generateReport(String path, List<JsonFeature> features) async {
    try {
      final file = File(path);
      final result = json.encode(_features.map((feature) => feature.toJson()).toList());
      await file.writeAsString(result);
    }
    catch (e) {
      print("Failed to generate json report: $e");
    }
  }
}