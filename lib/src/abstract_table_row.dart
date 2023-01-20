import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import '../simple_dart_table.dart';

abstract class AbstractTableRow extends PanelComponent {
  late List<TableColumnDescr> columns;

  List<AbstractTableCell> get cells;

  List<dynamic> get rowData;

  set rowData(List<dynamic> value);

  AbstractTableRow(this.columns) : super('TableRow');
}
