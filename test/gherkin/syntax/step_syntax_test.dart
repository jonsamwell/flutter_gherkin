import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/step.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/multiline_string_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/step_syntax.dart';
import 'package:flutter_gherkin/src/gherkin/syntax/table_line_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches given correctly', () {
      final syntax = StepSyntax();
      expect(syntax.isMatch("Given a step"), true);
      expect(syntax.isMatch("given a step"), true);
    });

    test('matches then correctly', () {
      final syntax = StepSyntax();
      expect(syntax.isMatch("Then a step"), true);
      expect(syntax.isMatch("then a step"), true);
    });

    test('matches when correctly', () {
      final syntax = StepSyntax();
      expect(syntax.isMatch("When I do something"), true);
      expect(syntax.isMatch("when I do something"), true);
    });

    test('matches and correctly', () {
      final syntax = StepSyntax();
      expect(syntax.isMatch("And something"), true);
      expect(syntax.isMatch("and something"), true);
    });

    test('matches but correctly', () {
      final syntax = StepSyntax();
      expect(syntax.isMatch("but something"), true);
      expect(syntax.isMatch("but something"), true);
    });

    test('does not match', () {
      final syntax = StepSyntax();
      expect(syntax.isMatch("#given something"), false);
    });
  });

  group("block", () {
    test("is block", () {
      final syntax = StepSyntax();
      expect(syntax.isBlockSyntax, true);
    });

    test("continue block if multiline string", () {
      final syntax = StepSyntax();
      expect(syntax.hasBlockEnded(MultilineStringSyntax()), false);
    });

    test("continue block if table", () {
      final syntax = StepSyntax();
      expect(syntax.hasBlockEnded(TableLineSyntax()), false);
    });

    test("end block if not multiline string or table", () {
      final syntax = StepSyntax();
      expect(syntax.hasBlockEnded(StepSyntax()), true);
    });
  });

  group("toRunnable", () {
    test('creates StepRunnable', () {
      final syntax = StepSyntax();
      final StepRunnable runnable = syntax.toRunnable(
          "Given I do something", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is StepRunnable));
      expect(runnable.name, equals("Given I do something"));
    });
  });
}
