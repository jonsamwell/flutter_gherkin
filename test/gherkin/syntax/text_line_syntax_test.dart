import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/text_line.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/text_line_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = new TextLineSyntax();
      expect(syntax.isMatch("Hello Jon"), true);
      expect(syntax.isMatch("Hello 'Jon'!"), true);
      expect(syntax.isMatch(" Hello Jon"), true);
      expect(syntax.isMatch("  Hello Jon"), true);
      expect(syntax.isMatch("   h "), true);
    });

    test('does not match', () {
      final syntax = new TextLineSyntax();
      expect(syntax.isMatch("#Hello Jon"), false);
      expect(syntax.isMatch("# Hello Jon"), false);
      expect(syntax.isMatch("#  Hello Jon"), false);
      expect(syntax.isMatch("      "), false);
      expect(syntax.isMatch(" #   h "), false);
    });
  });

  group("toRunnable", () {
    test('creates TextLineRunnable', () {
      final syntax = new TextLineSyntax();
      TextLineRunnable runnable = syntax.toRunnable(
          "  Some text ", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is TextLineRunnable));
      expect(runnable.text, equals("Some text"));
    });
  });
}
