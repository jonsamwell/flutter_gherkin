import 'package:flutter_gherkin/flutter_gherkin.dart';

import 'json_feature.dart';
import 'json_step.dart';

class JsonScenario {
  JsonFeature feature;
  String name;
  String description;
  int line;
  List<JsonStep> steps = [];

  static JsonScenario from(StartedMessage message) {
    final scenario = JsonScenario();
    scenario.name = message.name;
    scenario.description = "";
    scenario.line = message.context.lineNumber;
    return scenario;
  }

  void add({JsonStep step}) {
    steps.add(step);
  }

  JsonStep currentStep() {
    return steps.last;
  }

  String id() {
    return "${feature.id};${name.toLowerCase()}";
  }

  Map<String, dynamic> toJson() {
    final result = {
      "keyword": "Scenario",
      "type": "scenario",
      "id": id(),
      "name": name,
      "description": description,
      "line": line,
    };

    if (steps.isNotEmpty) {
      result["steps"] = steps.map((step) => step.toJson()).toList();
    }

    return result;
  }
}