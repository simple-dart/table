import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import 'table_cells.dart';

class TableRow extends PanelComponent {
  List<AbstractTableCell> cells = <AbstractTableCell>[];

  List<dynamic> get data => cells.map((e) => e.value).toList();

  set data(List<dynamic> value) {
    for (var i = 0; i < value.length; i++) {
      cells[i].value = value[i];
    }
  }

  TableRow() : super('TableRow') {
    fullWidth();
  }
}
