import 'dart:html';

import '../simple_dart_table.dart';

typedef TableValueToString = String Function(TableColumnDescr columnDescr, dynamic value);

class CopyTable {
  late TableValueToString valueToString;
  late Table table;
  bool _copyFull = false;

  CopyTable(this.table, this.valueToString) {
    table.element.onCopy.listen(copyToClipboardListener);
  }

  void copyToClipboard() {
    _copyFull = true;
    window.getSelection()!.selectAllChildren(table.element);
    document.execCommand('copy');
    window.getSelection()!.removeAllRanges();
    _copyFull = false;
  }

  void copyToClipboardListener(ClipboardEvent event) {
    if (_copyFull) {
      final cbData = StringBuffer()..writeln(table.columns.map((column) => column.caption).toList().join('\t'));
      for (final row in table.rows) {
        for (var i = 0; i < table.columns.length; i++) {
          final value = row.rowData[i];
          final column = table.columns[i];
          final formattedValue = valueToString(value, column);
          cbData.write('$formattedValue\t');
        }
        cbData.write('\n');
      }
      event.clipboardData!.setData('text/plain', cbData.toString());
      event.preventDefault();
    }
  }
}
