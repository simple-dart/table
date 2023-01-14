import 'package:simple_dart_image/simple_dart_image.dart';
import 'package:simple_dart_label/simple_dart_label.dart';
import 'package:simple_dart_link/simple_dart_link.dart';
import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

import 'table_column_descr.dart';
import 'table_image.dart';
import 'table_link.dart';

abstract class AbstractTableCell<T> implements Component {
  T get value;

  set value(T value);
}

class LabelTableCell extends Label implements AbstractTableCell<String> {
  LabelTableCell() {
    addCssClass('TableCell');
    shrinkable = true;
    breakWords = true;
    shrinkable = true;
  }

  @override
  set value(String value) {
    caption = value;
  }

  @override
  String get value => caption;
}

class LinkTableCell extends Link implements AbstractTableCell<TableLink> {
  LinkTableCell() {
    addCssClass('TableCell');
    shrinkable = true;
    breakWords = true;
    shrinkable = true;
  }

  @override
  set value(TableLink value) {
    caption = value.caption;
    href = value.url;
  }

  @override
  TableLink get value => TableLink(caption, href);
}

class MultilineTableCell extends PanelComponent implements AbstractTableCell<List<dynamic>> {
  MultilineTableCell() : super('MultilineTableCell') {
    addCssClass('TableCell');
    vertical = true;
    shrinkable = true;
  }

  @override
  set value(List<dynamic> value) {
    clear();
    addAll(value.map((e) => Label()..caption = e.toString()).toList());
  }

  @override
  List<dynamic> get value => children.map((e) => (e as Label).caption).toList();
}

class MultiComponentTableCell extends PanelComponent implements AbstractTableCell<List<dynamic>> {
  List<dynamic> _value = [];

  MultiComponentTableCell() : super('MultiComponentTableCell') {
    addCssClass('TableCell');
    vertical = true;
    shrinkable = true;
  }

  @override
  set value(List<dynamic> value) {
    clear();
    _value = value;
    addAll(value.map((e) => e as Component).toList());
  }

  @override
  List<dynamic> get value => _value;
}

class ComponentTableCell extends PanelComponent implements AbstractTableCell<Component> {
  @override
  late Component value;

  ComponentTableCell(this.value) : super('ComponentTableCell') {
    add(value);
  }
}

class ImageTableCell extends Image implements AbstractTableCell<TableImage> {
  late TableImage _value;

  ImageTableCell(TableImage content) {
    addCssClass('TableCell');
    value = content;
  }

  @override
  set value(TableImage value) {
    _value = value;
    source = value.url;
    width = '${value.width}px';
    height = '${value.height}px';
  }

  @override
  TableImage get value => _value;
}

class ColumnHeaderCell extends Label implements AbstractTableCell<TableColumnDescr> {
  late TableColumnDescr _columnDescr;

  ColumnHeaderCell(TableColumnDescr column) {
    addCssClass('TableCell');
    shrinkable = true;
    value = column;
  }

  @override
  set value(TableColumnDescr value) {
    _columnDescr = value;
    caption = value.caption;
    width = '${value.width}px';
    if (value.sortable) {
      addCssClass('Sortable');
    }
    hAlign = value.hAlign;
  }

  @override
  TableColumnDescr get value => _columnDescr;
}
