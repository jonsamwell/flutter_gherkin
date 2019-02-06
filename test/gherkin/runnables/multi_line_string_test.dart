import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/multi_line_string.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/text_line.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group("addChild", () {
    test('can add EmptyLineRunnable', () {
      final runnable = MultilineStringRunnable(debugInfo);
      runnable.addChild(EmptyLineRunnable(debugInfo));
    });
    test('can add TextLineRunnable', () {
      final runnable = MultilineStringRunnable(debugInfo);
      runnable.addChild(TextLineRunnable(debugInfo)..text = "1");
      runnable.addChild(TextLineRunnable(debugInfo)..text = "2");
      runnable.addChild(TextLineRunnable(debugInfo)..text = "3");
      expect(runnable.lines.length, 3);
      expect(runnable.lines, ["1", "2", "3"]);
    });
  });
}
