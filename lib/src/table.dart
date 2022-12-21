import 'dart:html';

import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import 'table_cells.dart';
import 'table_column_descr.dart';
import 'table_column_to_header_cell_default.dart';
import 'table_row.dart';
import 'table_value_to_cell_default.dart';
import 'table_value_to_string_default.dart';

typedef TableColumnToHeaderCell = AbstractTableCell Function(TableColumnDescr columnDescr);
typedef TableValueToCell = AbstractTableCell Function(TableColumnDescr columnDescr, dynamic value);
typedef TableValueToString = String Function(TableColumnDescr columnDescr, dynamic value);

class Table extends PanelComponent {
  late TableColumnToHeaderCell columnToHeaderCell;
  late TableValueToCell valueToCell;
  late TableValueToString valueToString;

  bool _copyFull = false;
  TableRow headersRow = TableRow()..addCssClass('Header');
  List<TableRow> rows = <TableRow>[];
  List<TableColumnDescr> columns = <TableColumnDescr>[];

  PanelComponent scrollablePanel = Panel()
    ..wrap = false
    ..vertical = true
    ..varName = 'scrollablePanel'
    ..scrollable = true
    ..fillContent = true
    ..fullSize();

  Table() : super('Table') {
    columnToHeaderCell = tableColumnToHeaderCellDefault;
    valueToCell = tableValueToCellDefault;
    valueToString = tableValueToStringDefault;
    vertical = true;
    element.style.flexShrink = '1';
    addAll([headersRow, scrollablePanel]);
    element.onCopy.listen(copyToClipboardListener);
  }

  TableColumnDescr createColumn(String header, int width,
      {bool sortable = false, Align hAlign = Align.start, int precision = 0}) {
    final column = TableColumnDescr()
      ..width = width
      ..caption = header
      ..sortable = sortable
      ..precision = precision
      ..hAlign = hAlign;
    columns.add(column);
    final headerCell = columnToHeaderCell(column);
    headersRow.cells.add(headerCell);
    headersRow.add(headerCell);
    if (sortable) {
      headerCell.element.onClick.listen((e) {
        var desc = false;
        if (headerCell.hasCssClass('Sorted')) {
          headerCell
            ..removeCssClass('Sorted')
            ..addCssClass('SortedDesc');
          desc = true;
        } else if (headerCell.hasCssClass('SortedDesc')) {
          headerCell.removeCssClass('SortedDesc');
        } else {
          headerCell.addCssClass('Sorted');
        }
        for (final otherHeaderCell in headersRow.cells) {
          if (otherHeaderCell == headerCell) {
            continue;
          } else {
            otherHeaderCell
              ..removeCssClass('Sorted')
              ..removeCssClass('SortedDesc');
          }
        }
        sortData(columnIndex: columns.indexOf(column), desc: desc);
      });
    }
    return column;
  }

  TableRow createRow(List<dynamic> cellValues) {
    final row = TableRow()..data = cellValues;
    var colLen = columns.length;
    if (colLen > cellValues.length) {
      colLen = cellValues.length;
    }
    for (var i = 0; i < colLen; i++) {
      final column = columns[i];
      final value = cellValues[i];
      final cell = valueToCell(column, value);

      final hAlign = column.hAlign;
      cell.element.style.justifyContent = hAlign.name;
      row.cells.add(cell);
      row.add(cell);
    }
    _addRow(row);
    return row;
  }

  void _addRow(TableRow simpleTableRow) {
    if (simpleTableRow.cells.length < columns.length) {
      for (var colNum = simpleTableRow.cells.length; colNum < columns.length; colNum++) {
        final emptyCell = LabelTableCell('');
        simpleTableRow.cells.add(emptyCell);
        simpleTableRow.add(emptyCell);
      }
    }
    if (columns.length == simpleTableRow.cells.length) {
      for (var i = 0; i < simpleTableRow.cells.length; i++) {
        simpleTableRow.cells[i].width = '${columns[i].width}px';
      }
    }
    formatRow(simpleTableRow);
    rows.add(simpleTableRow);
    scrollablePanel.add(simpleTableRow);
  }

  void formatRow(TableRow simpleTableRow) {
    final isEven = rows.length % 2 == 0;
    if (isEven) {
      simpleTableRow.addCssClass('Even');
    } else {
      simpleTableRow.addCssClass('Odd');
    }
  }

  @override
  void clear() {
    scrollablePanel.clear();
    rows.clear();
  }

  void copyToClipboard() {
    _copyFull = true;
    window.getSelection()!.selectAllChildren(element);
    document.execCommand('copy');
    window.getSelection()!.removeAllRanges();
    _copyFull = false;
  }

  void copyToClipboardListener(ClipboardEvent event) {
    if (_copyFull) {
      final cbData = StringBuffer()..writeln(headersRow.cells.map((cell) => cell.text).toList().join('\t'));
      for (final row in rows) {
        for (var i = 0; i < columns.length; i++) {
          final value = row.data[i];
          final column = columns[i];
          final formattedValue = valueToString(value, column);
          cbData.write('$formattedValue\t');
        }
        cbData.write('\n');
      }
      event.clipboardData!.setData('text/plain', cbData.toString());
      event.preventDefault();
    }
  }

  void sortData({int columnIndex = 0, bool desc = false}) {
    final rowData = <List<dynamic>>[];
    for (final row in rows) {
      rowData.add(row.data);
    }
    if (desc) {
      rowData.sort((a, b) {
        final data1 = a[columnIndex];
        final data2 = b[columnIndex];
        return compareDynamics(data2, data1);
      });
    } else {
      rowData.sort((a, b) {
        final data1 = a[columnIndex];
        final data2 = b[columnIndex];
        return compareDynamics(data1, data2);
      });
    }
    clear();
    rowData.forEach(createRow);
  }
}

int compareDynamics(dynamic a, dynamic b) {
  if (a == null && b == null) {
    return 0;
  }
  if (a == null) {
    return 1;
  }
  if (b == null) {
    return -1;
  }
  if (a is num && b is num) {
    return a.compareTo(b);
  }
  if (a is num && b is! num) {
    return 1;
  }
  if (a is! num && b is num) {
    return -1;
  }
  if (a is DateTime && b is DateTime) {
    return a.compareTo(b);
  }
  final aStr = a.toString();
  final bStr = b.toString();
  return aStr.compareTo(bStr);
}
