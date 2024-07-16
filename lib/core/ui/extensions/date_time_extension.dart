import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension DateTimeExtension on DateTime {
  String get toDateApi {
    // expected date format on string 2006-01-02T15:04:05Z
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(this);
  }

  String? formatDate({
    String? format,
    String? locale,
    bool? isShortDay,
    bool? isShortMonth,
    bool? isHideDayName,
    bool? isHideDayYear,
  }) {
    try {
      if (locale != null) {
        initializeDateFormatting();

        // final String dayName = DateFormat('EEEE', locale).format(this);
        late String dayName;
        if (isShortDay == true) {
          dayName = DateFormat.E(locale).format(this);
        } else {
          dayName = DateFormat.EEEE(locale).format(this);
        }

        late String monthName;
        if (isShortMonth == true) {
          monthName = DateFormat.MMM(locale).format(this);
        } else {
          monthName = DateFormat.MMMM(locale).format(this);
        }

        final String day = DateFormat.d().format(this);
        final String year = DateFormat.y().format(this);

        String result = '';
        if (isHideDayName != true) {
          result += '$dayName, ';
        }

        if (isHideDayYear != true) {
          result += '$day $monthName $year';
        } else {
          result += '$day $monthName';
        }

        // if (isHideDayName == true) {
        //   return '$day $monthName $year';
        // } else if (isShortMonth == true) {
        //   return '$day $monthName $year';
        // } else {
        //   return '$dayName, $day $monthName $year';
        // }

        return result;
      }

      return DateFormat(format ?? 'MM-dd-yyyy').format(this);
    } catch (e) {
      return null;
    }
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }
}
