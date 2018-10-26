import 'package:flutter_gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/table.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group("addChild", () {
    test('can add CommentLineRunnable', () {
      final runnable = new TableRunnable(debugInfo);
      runnable.addChild(CommentLineRunnable("", debugInfo));
    });
    test('can add TableRunnable', () {
      final runnable = new TableRunnable(debugInfo);
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add("| Header 1 | Header 2 |"));
      runnable.addChild(TableRunnable(debugInfo)..rows.add("|  1 | 2 |"));
      runnable.addChild(TableRunnable(debugInfo)..rows.add("|  3 | 4 |"));
      expect(runnable.rows.length, 3);
      expect(runnable.rows,
          ["| Header 1 | Header 2 |", "|  1 | 2 |", "|  3 | 4 |"]);
    });
  });

  group("to table", () {
    test("single row table has no header row", () async {
      final runnable = new TableRunnable(debugInfo);
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add("| one | two | three |"));
      final table = runnable.toTable();
      expect(table.header, isNull);
      expect(table.rows.length, 1);
      expect(table.rows.first.columns, ["one", "two", "three"]);
    });

    test("two row table has header row", () async {
      final runnable = new TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add("| header one | header two | header three |"));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add("| one | two | three |"));
      final table = runnable.toTable();
      expect(table.header, isNotNull);
      expect(
          table.header.columns, ["header one", "header two", "header three"]);
      expect(table.rows.length, 1);
      expect(table.rows.elementAt(0).columns, ["one", "two", "three"]);
    });

    test("three row table has header row and correct rows", () async {
      final runnable = new TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add("| header one | header two | header three |"));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add("| one | two | three |"));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add("| four | five | six |"));
      final table = runnable.toTable();
      expect(table.header, isNotNull);
      expect(
          table.header.columns, ["header one", "header two", "header three"]);
      expect(table.rows.length, 2);
      expect(table.rows.elementAt(0).columns, ["one", "two", "three"]);
      expect(table.rows.elementAt(1).columns, ["four", "five", "six"]);
    });

    test("table removes columns leading and trailing spaces", () async {
      final runnable = new TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add("| header one | header two | header three |"));
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add("|   one |    two    |       three          |"));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add("|four    |     five    |six|"));
      final table = runnable.toTable();
      expect(table.header, isNotNull);
      expect(
          table.header.columns, ["header one", "header two", "header three"]);
      expect(table.rows.length, 2);
      expect(table.rows.elementAt(0).columns, ["one", "two", "three"]);
      expect(table.rows.elementAt(1).columns, ["four", "five", "six"]);
    });
  });
}
