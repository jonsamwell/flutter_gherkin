class TableRow {
  final bool isHeaderRow;
  final int rowIndex;
  final Iterable<String> columns;

  TableRow(this.columns, this.rowIndex, this.isHeaderRow);
}
