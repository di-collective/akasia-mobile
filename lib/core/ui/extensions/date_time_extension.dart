import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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

  DateTime get firstHourOfDay {
    return DateTime(year, month, day, 0, 0, 0, 0, 0);
  }

  DateTime get lastHourOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999, 999);
  }

  String get hourMinute {
    return DateFormat('HH:mm').format(this);
  }

  bool isSameDay({
    required DateTime? other,
  }) {
    return year == other?.year && month == other?.month && day == other?.day;
  }

  String formmatDateRange({
    required DateTime? endDate,
  }) {
    final startDate = formatDate(format: 'dd') ?? '';
    final endDateFormatted = endDate?.formatDate(format: 'dd MMM yyyy') ?? '';

    return '$startDate - $endDateFormatted';
  }

  DateTime get firstDayOfTheWeek {
    // first date is monday
    final int day = weekday;

    return subtract(Duration(days: day - 1));
  }

  DateTime get lastDayOfTheWeek {
    // last date is sunday
    final int day = weekday;

    return add(Duration(days: 7 - day));
  }
}
