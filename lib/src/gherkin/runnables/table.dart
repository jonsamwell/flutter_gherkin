import 'package:flutter_gherkin/src/gherkin/models/table.dart';
import 'package:flutter_gherkin/src/gherkin/models/table_row.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/runnable_block.dart';

class TableRunnable extends RunnableBlock {
  final List<String> rows = List<String>();

  @override
  String get name => "Table";

  TableRunnable(RunnableDebugInformation debug) : super(debug);

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case TableRunnable:
        rows.addAll((child as TableRunnable).rows);
        break;
      case CommentLineRunnable:
        break;
      default:
        throw new Exception(
            "Unknown runnable child given to Table '${child.runtimeType}'");
    }
  }

  Table toTable() {
    TableRow header;
    List<TableRow> tableRows = List<TableRow>();
    if (rows.length > 1) {
      header = _toRow(rows.first, 0, true);
    }

    for (var i = (header == null ? 0 : 1); i < rows.length; i += 1) {
      tableRows.add(_toRow(rows.elementAt(i), i));
    }

    return Table(tableRows, header);
  }

  TableRow _toRow(String raw, int rowIndex, [isHeaderRow = false]) {
    return TableRow(
        raw
            .split(RegExp(r"\|"))
            .map((c) => c.trim())
            .where((c) => c.isNotEmpty),
        rowIndex,
        isHeaderRow);
  }
}
