import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/language.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group("addChild", () {
    test('can add LangaugeRunnable', () {
      final runnable = FeatureFile(debugInfo);
      runnable.addChild(LanguageRunnable(debugInfo)..language = "en");
      expect(runnable.langauge, "en");
    });
    test('can add TagsRunnable', () {
      final runnable = FeatureFile(debugInfo);
      runnable.addChild(FeatureRunnable("1", debugInfo));
      runnable.addChild(FeatureRunnable("2", debugInfo));
      runnable.addChild(FeatureRunnable("3", debugInfo));
      expect(runnable.features.length, 3);
    });
  });
}
