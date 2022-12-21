import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import 'table_cells.dart';
import 'table_column_descr.dart';
import 'table_image.dart';
import 'table_link.dart';

AbstractTableCell tableValueToCellDefault(TableColumnDescr columnDescr, dynamic value) {
  AbstractTableCell cell;
  if (value is TableLink) {
    cell = LinkTableCell(value);
  } else if (value is TableImage) {
    cell = ImageTableCell(value);
  } else if (value is Component) {
    cell = ComponentTableCell(value);
  } else if (value is List<String>) {
    cell = MultilineTableCell(value);
  } else if (value is List) {
    cell = MultiComponentTableCell(value);
  } else {
    var valueStr = '';
    if (value == null) {
      valueStr = '';
    } else if (value is num) {
      valueStr = value.toStringAsFixed(columnDescr.precision);
    } else if (value is DateTime) {
      valueStr = formatDateHum(value);
    } else {
      valueStr = value.toString();
    }
    cell = LabelTableCell(valueStr);
  }
  return cell;
}

String formatDateHum(DateTime date) => '${date.day.toString().padLeft(2, '0')}.'
    '${date.month.toString().padLeft(2, '0')}.'
    '${date.year.toString()}';
