import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  // Format a single DateTime to 'yyyy-MM-dd'
  String formatDateString() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(this);
  }
}

extension DateRangeFormatter on DateTime? {
  // Format a range of two dates
  String formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return '';
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return 'Selected Date Range: ${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}
