import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatToLocal({
    bool? isHideDayName,
    bool? isShortMonth,
    String? locale,
  }) {
    initializeDateFormatting();

    final String dayName = DateFormat('EEEE', locale).format(this);
    late String monthName;
    if (isShortMonth == true) {
      monthName = DateFormat.MMM('id').format(this);
    } else {
      monthName = DateFormat.MMMM('id').format(this);
    }

    final String day = DateFormat.d().format(this);
    final String year = DateFormat.y().format(this);

    if (isHideDayName == true) {
      return '$day $monthName $year';
    } else if (isShortMonth == true) {
      return '$day $monthName $year';
    } else {
      return '$dayName, $day $monthName $year';
    }
  }

  String get toDateApi {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
