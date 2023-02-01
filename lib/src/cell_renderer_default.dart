import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import '../simple_dart_table.dart';

class CellRendererDefault extends CellRenderer {
  @override
  bool checkCellByType(AbstractTableCell cell, dynamic value) {
    if ((value == null) && cell is NullTableCell) {
      return true;
    }
    if ((value is String) && cell is LabelTableCell) {
      return true;
    }
    if (value is TableColumnDescr && cell is ColumnHeaderCell) {
      return true;
    }
    if (value is bool && cell is BooleanTableCell) {
      return true;
    }
    if (value is num && cell is NumTableCell) {
      return true;
    }
    if (value is DateTime && cell is DateTimeTableCell) {
      return true;
    }
    if (value is TableLink && cell is LinkTableCell) {
      return true;
    }
    if (value is TableImage && cell is ImageTableCell) {
      return true;
    }
    if (value is Component && cell is ComponentTableCell) {
      return true;
    }
    if (value is List<String> && cell is MultilineTableCell) {
      return true;
    }
    if (value is List<Component> && cell is MultiComponentTableCell) {
      return true;
    }
    return false;
  }

  @override
  AbstractTableCell createCellByType(TableColumnDescr columnDescr, dynamic value) {
    if (value == null) {
      return NullTableCell();
    }
    if (value is String) {
      return LabelTableCell();
    }
    if (value is TableColumnDescr) {
      return createColumnHeader(value);
    }
    if (value is bool) {
      return BooleanTableCell()..value = value;
    }
    if (value is num) {
      return NumTableCell()
        ..precision = columnDescr.precision ?? 0
        ..value = value;
    }
    if (value is DateTime) {
      return DateTimeTableCell()..value = value;
    }
    if (value is TableLink) {
      return LinkTableCell()..value = value;
    }
    if (value is TableImage) {
      return ImageTableCell(value);
    }
    if (value is Component) {
      return ComponentTableCell(value);
    }
    if (value is List<String>) {
      return MultilineTableCell()..value = value;
    }
    if (value is List<Component>) {
      return MultiComponentTableCell()..value = value;
    }
    throw Exception('Unsupported type of value: ${value.runtimeType}');
  }

  AbstractTableCell createColumnHeader(TableColumnDescr columnDescr) => ColumnHeaderCell(columnDescr);
}
