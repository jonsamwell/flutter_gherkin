import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/feature_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final keyword = new FeatureSyntax();
      expect(keyword.isMatch("Feature: one"), true);
      expect(keyword.isMatch("Feature:one"), true);
    });

    test('does not match', () {
      final keyword = new FeatureSyntax();
      expect(keyword.isMatch("#Feature: no"), false);
      expect(keyword.isMatch("# Feature no"), false);
    });
  });

  group("toRunnable", () {
    test('creates FeatureRunnable', () {
      final keyword = new FeatureSyntax();
      Runnable runnable = keyword.toRunnable(
          "Feature: A feature 123", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is FeatureRunnable));
      expect(runnable.name, equals("A feature 123"));
    });
  });
}
