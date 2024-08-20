import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../utils/logger.dart';

extension DateTimeExtension on DateTime {
  /// Converts a `DateTime` object to a string using the format `yyyy-MM-dd'T'HH:mm:ssZ07:00`.
  ///
  /// Returns:
  /// - A string representing the `DateTime` in the specified format, including the timezone offset.
  /// - `null`: If an error occurs during the conversion.
  ///
  /// Note:
  /// - The resulting string will follow this pattern: `2006-01-02T15:04:05Z07:00`.
  String? get toDateApi {
    try {
      final date = this;

      // Get the formatted date string without timezone
      String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date);

      // Get the timezone offset in hours and minutes
      String timeZoneOffset = date.timeZoneOffset.isNegative ? '-' : '+';
      timeZoneOffset +=
          '${date.timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}:';
      timeZoneOffset +=
          (date.timeZoneOffset.inMinutes.abs() % 60).toString().padLeft(2, '0');

      // Combine the formatted date with the timezone offset
      final formattedString = formattedDate + timeZoneOffset;

      Logger.success('toDateApi formattedString: $formattedString');

      return formattedString;
    } catch (error) {
      Logger.error('toDateApi error: $error');

      return null;
    }
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

        if (format != null) {
          return DateFormat(format, locale).format(this);
        }

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

  DateTime addYears(int year) {
    return add(Duration(days: year * 365));
  }

  // TODO: Rename this to startOfDay
  DateTime get firstHourOfDay {
    return DateTime(year, month, day, 0, 0, 0, 0, 0);
  }

  DateTime get lastHourOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999, 999);
  }

  String get hourMinute {
    return DateFormat('HH:mm').format(this);
  }

  // FIXME: Migrate to use isSame
  bool isSameDay({
    required DateTime? other,
  }) {
    return year == other?.year && month == other?.month && day == other?.day;
  }

  bool isSame({
    required DateTime? other,
    bool? withoutYear,
    bool? withoutMonth,
    bool? withoutDay,
    bool? withoutHour,
    bool? withoutMinute,
    bool? withoutSecond,
  }) {
    if (other == null) return false;

    if (withoutYear != true && year != other.year) return false;
    if (withoutMonth != true && month != other.month) return false;
    if (withoutDay != true && day != other.day) return false;
    if (withoutHour != true && hour != other.hour) return false;
    if (withoutMinute == true && minute != other.minute) return false;
    if (withoutSecond != true && second != other.second) return false;

    return true;
  }

  String formatDateRange({
    required DateTime? endDate,
    String? formatStartDate,
    String? formatEndDate,
  }) {
    final startDate = formatDate(format: formatStartDate ?? 'dd') ?? '';
    final endDateFormatted =
        endDate?.formatDate(format: formatEndDate ?? 'dd MMM yyyy') ?? '';

    return '$startDate-$endDateFormatted';
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

  DateTime get onlyYearMonth {
    return DateTime(year, month);
  }

  static List<DateTime> get daysInWeek {
    final List<DateTime> result = [];
    final DateTime currentDate = DateTime.now();
    final DateTime firstDate = currentDate.firstDayOfTheWeek;

    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      result.add(firstDate.add(Duration(days: i)));
    }

    return result;
  }

  bool get isToday {
    final now = DateTime.now();

    return isSameDay(other: now);
  }

  int? dateRangeInWeeks({
    required DateTime? startDate,
  }) {
    if (startDate == null) {
      return null;
    }

    final difference = this.difference(startDate);

    return (difference.inDays / 7).ceil();
  }
}
