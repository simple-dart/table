import 'package:simple_dart_image/simple_dart_image.dart';
import 'package:simple_dart_label/simple_dart_label.dart';
import 'package:simple_dart_link/simple_dart_link.dart';
import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';
import 'package:simple_dart_utils_date_time/simple_dart_utils_date_time.dart' as utils_date_time;

import '../simple_dart_table.dart';

class LabelTableCell extends Label implements AbstractTableCell<String> {
  LabelTableCell() {
    addCssClass('TableCell');
    shrinkable = true;
    breakWords = true;
  }

  @override
  set value(String value) {
    caption = value;
  }

  @override
  String get value => caption;
}

class BooleanTableCell extends Label implements AbstractTableCell<bool> {
  BooleanTableCell() {
    addCssClass('TableCell');
    shrinkable = true;
    breakWords = true;
  }

  @override
  set value(bool value) {
    caption = value.toString();
  }

  @override
  bool get value => caption == 'true';
}

class NumTableCell extends Label implements AbstractTableCell<num?> {
  int precision = 0;
  num? _value;

  NumTableCell() {
    addCssClass('TableCell');
    shrinkable = true;
    breakWords = true;
    shrinkable = true;
  }

  @override
  set value(num? value) {
    _value = value;
    caption = value?.toStringAsFixed(precision) ?? '-';
  }

  @override
  num? get value => _value;
}

class DateTimeTableCell extends Label implements AbstractTableCell<DateTime?> {
  bool showTime = false;
  DateTime? _value;

  DateTimeTableCell() {
    addCssClass('TableCell');
    shrinkable = true;
    breakWords = true;
    shrinkable = true;
  }

  @override
  set value(DateTime? value) {
    _value = value;
    if (value == null) {
      caption = '-';
    } else {
      if (showTime) {
        caption = utils_date_time.formatDateTimeHum(value);
      } else {
        caption = utils_date_time.formatDateHum(value);
      }
    }
  }

  @override
  DateTime? get value => _value;
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

class MultiComponentTableCell extends PanelComponent implements AbstractTableCell<List<Component>> {
  List<Component> _value = [];

  MultiComponentTableCell() : super('MultiComponentTableCell') {
    addCssClass('TableCell');
    vertical = true;
    shrinkable = true;
  }

  @override
  set value(List<Component> value) {
    clear();
    _value = value;
    addAll(value);
  }

  @override
  List<Component> get value => _value;
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
