import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  String formatDateString() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(this);
  }
}
