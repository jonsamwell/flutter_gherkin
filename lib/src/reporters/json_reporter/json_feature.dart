import 'package:flutter_gherkin/flutter_gherkin.dart';

import 'json_scenario.dart';

class JsonFeature  {
  String uri;
  String id;
  String name;
  String description;
  int line;
  List<JsonScenario> scenarios = [];

  static JsonFeature from(StartedMessage message) {
    final feature = JsonFeature();
    feature.uri = message.context.filePath;
    feature.id = message.name.toLowerCase();
    feature.name = message.name;
    feature.description = "";
    feature.line = message.context.lineNumber;
    return feature;
  }

  void add({JsonScenario scenario}) {
    scenario.feature = this;
    scenarios.add(scenario);
  }

  JsonScenario currentScenario() {
    return scenarios.last;
  }

  Map<String, dynamic> toJson() {
    final result = {
      "keyword": "Feature",
      "uri": uri,
      "id": id,
      "name": name,
      "description": description,
      "line": line,
    };

    if (scenarios.isNotEmpty) {
      result["elements"] = scenarios.map((scenario) => scenario.toJson()).toList();
    }

    return result;
  }
}
