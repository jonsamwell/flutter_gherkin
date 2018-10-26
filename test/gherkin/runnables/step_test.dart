import 'package:flutter_gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/multi_line_string.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/step.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/table.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group("addChild", () {
    test('can add MultilineStringRunnable', () {
      final runnable = new StepRunnable("", debugInfo);
      runnable.addChild(
          MultilineStringRunnable(debugInfo)..lines = ["1", "2", "3"].toList());
      runnable.addChild(
          MultilineStringRunnable(debugInfo)..lines = ["3", "4", "5"].toList());
      expect(runnable.multilineStrings.length, 2);
      expect(runnable.multilineStrings.elementAt(0), "1\n2\n3");
      expect(runnable.multilineStrings.elementAt(1), "3\n4\n5");
    });

    test('can add TableRunnable', () {
      final runnable = new StepRunnable("", debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..addChild(TableRunnable(debugInfo)..rows.add("|Col A|Col B|"))
        ..addChild(TableRunnable(debugInfo)..rows.add("|1|2|"))
        ..addChild(TableRunnable(debugInfo)..rows.add("|3|4|")));

      expect(runnable.table, isNotNull);
      expect(runnable.table.header, isNotNull);
      expect(runnable.table.header.columns.length, 2);
      expect(runnable.table.rows.length, 2);
    });

    test('can only add single TableRunnable', () {
      final runnable = new StepRunnable("Step A", debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..addChild(TableRunnable(debugInfo)..rows.add("|Col A|Col B|"))
        ..addChild(TableRunnable(debugInfo)..rows.add("|1|2|"))
        ..addChild(TableRunnable(debugInfo)..rows.add("|3|4|")));

      expect(
          () => runnable.addChild(TableRunnable(debugInfo)
            ..addChild(TableRunnable(debugInfo)..rows.add("|Col A|Col B|"))
            ..addChild(TableRunnable(debugInfo)..rows.add("|1|2|"))
            ..addChild(TableRunnable(debugInfo)..rows.add("|3|4|"))),
          throwsA((e) =>
              e is GherkinSyntaxException &&
              e.message ==
                  "Only a single table can be added to the step 'Step A'"));
    });
  });
}
