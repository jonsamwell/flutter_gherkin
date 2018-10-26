import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/scenario.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/step.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/tags.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group("addChild", () {
    test('can add EmptyLineRunnable', () {
      final runnable = new ScenarioRunnable("", debugInfo);
      runnable.addChild(EmptyLineRunnable(debugInfo));
    });
    test('can add StepRunnable', () {
      final runnable = new ScenarioRunnable("", debugInfo);
      runnable.addChild(StepRunnable("1", debugInfo));
      runnable.addChild(StepRunnable("2", debugInfo));
      runnable.addChild(StepRunnable("3", debugInfo));
      expect(runnable.steps.length, 3);
      expect(runnable.steps.elementAt(0).name, "1");
      expect(runnable.steps.elementAt(1).name, "2");
      expect(runnable.steps.elementAt(2).name, "3");
    });
    test('can add TagsRunnable', () {
      final runnable = new ScenarioRunnable("", debugInfo);
      runnable.addChild(TagsRunnable(debugInfo)..tags = ["one", "two"]);
      runnable.addChild(TagsRunnable(debugInfo)..tags = ["three"]);
      expect(runnable.tags, ["one", "two", "three"]);
    });
  });
}
