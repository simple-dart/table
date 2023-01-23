import '../simple_dart_table.dart';

abstract class CellRenderer {
  bool checkCellByType(AbstractTableCell cell, dynamic value);

  AbstractTableCell createCellByType(TableColumnDescr columnDescr, dynamic value);
}

class TableRow extends AbstractTableRow {
  late CellRenderer cellFactory;

  final List<AbstractTableCell> _cells = <AbstractTableCell>[];

  @override
  List<AbstractTableCell> get cells => _cells;

  @override
  List<dynamic> get rowData => cells.map((e) => e.value).toList();

  @override
  set rowData(List<dynamic> value) {
    for (var colNum = 0; colNum < value.length; colNum++) {
      createOrUpdateCell(colNum, value[colNum]);
    }
  }

  TableRow(List<TableColumnDescr> newCols) : super(newCols) {
    cellFactory = CellRendererDefault();
  }

  void createOrUpdateCell(int colNum, dynamic value) {
    final existCell = cells.length > colNum ? cells[colNum] : null;
    final columnDescr = columns.length > colNum ? columns[colNum] : TableColumnDescr();
    if (existCell == null) {
      final cell = cellFactory.createCellByType(columnDescr, value)
        ..value = value
        ..width = '${columnDescr.width}px';
      cells.add(cell);
      add(cell);
    } else {
      final isCompatibleCell = cellFactory.checkCellByType(existCell, value);
      if (isCompatibleCell) {
        existCell.value = value;
      } else {
        final newCell = cellFactory.createCellByType(columnDescr, value)
          ..value = value
          ..width = '${columnDescr.width}px';
        cells[colNum].remove();
        insert(colNum, newCell);
        cells[colNum] = newCell;
      }
    }
  }
}
