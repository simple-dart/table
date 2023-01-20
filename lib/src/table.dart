import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import '../simple_dart_table.dart';

class Table extends PanelComponent {
  late AbstractTableRow headersRow;
  List<AbstractTableRow> rows = <AbstractTableRow>[];
  List<TableColumnDescr> columns = <TableColumnDescr>[];

  PanelComponent scrollablePanel = Panel()
    ..wrap = false
    ..vertical = true
    ..varName = 'scrollablePanel'
    ..scrollable = true
    ..fillContent = true
    ..fullSize();

  Table() : super('Table') {
    addCssClass('Table');
    add(scrollablePanel);
    vertical = true;
    shrinkable = true;
  }

  AbstractTableRow createRow(List<dynamic> rowData) {
    final row = TableRow(columns)..rowData = rowData;
    formatRow(row);
    rows.add(row);
    scrollablePanel.add(row);
    return row;
  }

  void initColumns(List<TableColumnDescr> columns) {
    this.columns = columns;
    headersRow = TableRow(columns)
      ..addCssClass('Header')
      ..rowData = columns;
    for (var i = 0; i < columns.length; i++) {
      final columnDescr = columns[i];
      final headerCell = headersRow.cells[i];
      if (columnDescr.sortable) {
        headerCell.element.onClick.listen((event) {
          onSortClick(headerCell, i);
        });
      }
    }
    addAll([headersRow, scrollablePanel]);
  }

  void formatRow(AbstractTableRow row) {
    final isEven = rows.length % 2 == 0;
    if (isEven) {
      row.addCssClass('Even');
    } else {
      row.addCssClass('Odd');
    }
  }

  @override
  void clear() {
    scrollablePanel.clear();
    rows.clear();
  }

  void sortData({int columnIndex = 0, bool desc = false}) {
    final rowData = <List<dynamic>>[];
    for (final row in rows) {
      rowData.add(row.rowData);
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
    for (var i = 0; i < rowData.length; i++) {
      rows[i].rowData = rowData[i];
    }
  }

  void onSortClick(AbstractTableCell headerCell, int columnIndex) {
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
    sortData(columnIndex: columnIndex, desc: desc);
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
