import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/scenario.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/scenario_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = ScenarioSyntax();
      expect(syntax.isMatch("Scenario: something"), true);
      expect(syntax.isMatch(" Scenario:   something"), true);
    });

    test('does not match', () {
      final syntax = ScenarioSyntax();
      expect(syntax.isMatch("Scenario something"), false);
      expect(syntax.isMatch("#Scenario: something"), false);
    });
  });

  group("toRunnable", () {
    test('creates FeatureRunnable', () {
      final keyword = ScenarioSyntax();
      final Runnable runnable = keyword.toRunnable(
          "Scenario: A scenario 123", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is ScenarioRunnable));
      expect(runnable.name, equals("A scenario 123"));
    });
  });
}
