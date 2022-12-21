import 'package:simple_dart_image/simple_dart_image.dart';
import 'package:simple_dart_label/simple_dart_label.dart';
import 'package:simple_dart_link/simple_dart_link.dart';
import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import 'table_column_descr.dart';
import 'table_image.dart';
import 'table_link.dart';

abstract class AbstractTableCell implements Component {
  String get text;
}

class LabelTableCell extends Label implements AbstractTableCell {
  LabelTableCell(String content) {
    addCssClass('TableCell');
    caption = content;
    shrinkable = true;
    breakWords = true;
    shrinkable = true;
  }

  @override
  String get text => caption;
}

class LinkTableCell extends Link implements AbstractTableCell {
  LinkTableCell(TableLink content) {
    addCssClass('TableCell');
    caption = content.caption;
    href = content.url;
    shrinkable = true;
    breakWords = true;
    shrinkable = true;
  }

  @override
  String get text => caption;
}

class MultilineTableCell extends PanelComponent implements AbstractTableCell {
  MultilineTableCell(List<dynamic> content) : super('MultilineTableCell') {
    addCssClass('TableCell');
    vertical = true;
    shrinkable = true;
    addAll(content.map((e) => Label()..caption = e.toString()).toList());
  }

  @override
  String get text => children.map((e) => (e as Label).caption).join('/n');
}

class MultiComponentTableCell extends PanelComponent implements AbstractTableCell {
  MultiComponentTableCell(List<dynamic> content) : super('MultiComponentTableCell') {
    addCssClass('TableCell');
    vertical = true;
    shrinkable = true;
    addAll(content.map((e) => e as Component).toList());
  }

  @override
  String get text => children.map((e) => (e as Label).caption).join('/n');
}

class ComponentTableCell extends PanelComponent implements AbstractTableCell {
  ComponentTableCell(Component comp) : super('ComponentTableCell') {
    add(comp);
  }

  @override
  String get text => element.text ?? '';
}

class ImageTableCell extends Image implements AbstractTableCell {
  ImageTableCell(TableImage content) {
    addCssClass('TableCell');
    source = content.url;
    width = '${content.width}px';
    height = '${content.height}px';
  }

  @override
  String get text => source;
}

class ColumnHeaderCell extends Label implements AbstractTableCell {
  ColumnHeaderCell(TableColumnDescr column) {
    addCssClass('TableCell');
    caption = column.caption;
    width = '${column.width}px';
    if (column.sortable) {
      addCssClass('Sortable');
    }
    hAlign = column.hAlign;
    shrinkable = true;
  }

  @override
  String get text => caption;
}
