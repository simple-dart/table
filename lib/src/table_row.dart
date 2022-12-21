import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import 'table_cells.dart';

class TableRow extends PanelComponent {
  List<AbstractTableCell> cells = <AbstractTableCell>[];
  late List<dynamic> data;

  TableRow() : super('TableRow') {
    fullWidth();
  }
}
