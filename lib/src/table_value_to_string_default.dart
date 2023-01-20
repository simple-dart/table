import 'package:simple_dart_utils_date_time/simple_dart_utils_date_time.dart' as utils_date_time;

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
  } else if (value is num && columnDescr.precision != null) {
    formattedValue = value.toStringAsFixed(columnDescr.precision!).replaceAll('.', ',');
  } else if (value is DateTime) {
    formattedValue = utils_date_time.formatDateTime(value);
  } else {
    formattedValue = value.toString();
  }
  return formattedValue;
}
