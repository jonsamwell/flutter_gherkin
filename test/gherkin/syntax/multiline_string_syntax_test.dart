import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/multi_line_string.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/text_line_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = MultilineStringSyntax();
      expect(syntax.isMatch('"""'), true);
      expect(syntax.isMatch('```'), true);
      expect(syntax.isMatch("'''"), true);
    });

    test('does not match', () {
      final syntax = MultilineStringSyntax();
      expect(syntax.isMatch('#"""'), false);
      expect(syntax.isMatch('#```'), false);
      expect(syntax.isMatch("#'''"), false);
      expect(syntax.isMatch('"'), false);
      expect(syntax.isMatch('`'), false);
      expect(syntax.isMatch("'"), false);
    });
  });
  group("block", () {
    test("is block", () {
      final syntax = MultilineStringSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test("continue block if text line string", () {
      final syntax = MultilineStringSyntax();
      expect(syntax.hasBlockEnded(TextLineSyntax()), false);
    });

    test("continue block if comment string", () {
      final syntax = MultilineStringSyntax();
      expect(syntax.hasBlockEnded(CommentSyntax()), false);
    });

    test("end block if multiline string", () {
      final syntax = MultilineStringSyntax();
      expect(syntax.hasBlockEnded(MultilineStringSyntax()), true);
    });
  });

  group("toRunnable", () {
    test('creates TextLineRunnable', () {
      final syntax = MultilineStringSyntax();
      final MultilineStringRunnable runnable =
          syntax.toRunnable("'''", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is MultilineStringRunnable));
      expect(runnable.lines.length, 0);
    });
  });
}
