import 'table_column_descr.dart';
import 'table_image.dart';
import 'table_link.dart';

String tableValueToStringDefault(TableColumnDescr columnDescr, dynamic value) {
  String formattedValue;
  if (value is TableLink) {
    formattedValue = value.caption;
  } else if (value is TableImage) {
    formattedValue = value.url;
  } else if (value is List) {
    formattedValue = value.join(';');
  } else if (value == null) {
    formattedValue = '';
  } else if (value is num) {
    formattedValue = value.toStringAsFixed(columnDescr.precision).replaceAll('.', ',');
  } else {
    formattedValue = value.toString();
  }
  return formattedValue;
}
