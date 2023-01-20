import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

abstract class AbstractTableCell<T> implements Component {
  T get value;

  set value(T value);
}
