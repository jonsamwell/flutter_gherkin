import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/multi_line_string.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/text_line_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = new MultilineStringSyntax();
      expect(syntax.isMatch('"""'), true);
      expect(syntax.isMatch('```'), true);
      expect(syntax.isMatch("'''"), true);
    });

    test('does not match', () {
      final syntax = new MultilineStringSyntax();
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
      final syntax = new MultilineStringSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test("continue block if text line string", () {
      final syntax = new MultilineStringSyntax();
      expect(syntax.hasBlockEnded(new TextLineSyntax()), false);
    });

    test("continue block if comment string", () {
      final syntax = new MultilineStringSyntax();
      expect(syntax.hasBlockEnded(new CommentSyntax()), false);
    });

    test("end block if multiline string", () {
      final syntax = new MultilineStringSyntax();
      expect(syntax.hasBlockEnded(new MultilineStringSyntax()), true);
    });
  });

  group("toRunnable", () {
    test('creates TextLineRunnable', () {
      final syntax = new MultilineStringSyntax();
      MultilineStringRunnable runnable =
          syntax.toRunnable("'''", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is MultilineStringRunnable));
      expect(runnable.lines.length, 0);
    });
  });
}
