import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/table.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/comment_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/step_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/table_line_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = TableLineSyntax();
      expect(syntax.isMatch('||'), true);
      expect(syntax.isMatch(' | | '), true);
      expect(syntax.isMatch("  |a|b|c| "), true);
    });

    test('does not match', () {
      final syntax = TableLineSyntax();
      expect(syntax.isMatch('#||'), false);
      expect(syntax.isMatch(' |  '), false);
      expect(syntax.isMatch("  |a|b|c "), false);
    });
  });

  group("block", () {
    test("is block", () {
      final syntax = TableLineSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test("continue block if table line string", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(TableLineSyntax()), false);
    });

    test("continue block if comment string", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(CommentSyntax()), false);
    });

    test("end block if not table line string", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(MultilineStringSyntax()), true);
    });
  });

  group("block", () {
    test("is block", () {
      final syntax = TableLineSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test("continue block if table line", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(TableLineSyntax()), false);
    });

    test("continue block if comment string", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(CommentSyntax()), false);
    });

    test("end block if step", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(StepSyntax()), true);
    });

    test("end block if multiline string", () {
      final syntax = TableLineSyntax();
      expect(syntax.hasBlockEnded(MultilineStringSyntax()), true);
    });
  });

  group("toRunnable", () {
    test('creates TableRunnable', () {
      final syntax = TableLineSyntax();
      final TableRunnable runnable = syntax.toRunnable(
          " | Row One | Row Two | ", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is TableRunnable));
      expect(runnable.rows.elementAt(0), "| Row One | Row Two |");
      expect(runnable.rows.length, 1);
    });
  });
}
