import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get toDateApi {
    // expected date format on string 2006-01-02T15:04:05Z
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(this);
  }

  String? formatDate({
    String? format,
  }) {
    try {
      return DateFormat(format ?? 'MM-dd-yyyy').format(this);
    } catch (e) {
      return null;
    }
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }
}
