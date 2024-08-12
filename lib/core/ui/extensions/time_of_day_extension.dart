import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get toTimeMinute {
    String parseMinute = minute.toString();
    if (parseMinute.length == 1) {
      parseMinute = '0$parseMinute';
    }

    return '$hour:$parseMinute';
  }

  String formatTime({
    bool? showPeriod,
  }) {
    String formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');

    if (showPeriod == true) {
      final period = hour >= 12 ? 'PM' : 'AM';

      final formattedHour = hourOfPeriod.toString().padLeft(2, '0');
      return '$formattedHour:$formattedMinute $period';
    }

    return '$formattedHour:$formattedMinute';
  }

  bool isBefore({
    required TimeOfDay? otherValue,
    int? intervalMinutes,
  }) {
    if (otherValue == null) {
      return false;
    }

    if (hour < otherValue.hour) {
      if (intervalMinutes != null) {
        final currentMinutes = (hour * 60) + minute;
        if (currentMinutes % intervalMinutes != 0) {
          return false;
        }
      }

      return true;
    }

    if (hour == otherValue.hour && minute < otherValue.minute) {
      return true;
    }

    return false;
  }

  bool isAfter({
    required TimeOfDay? otherValue,
  }) {
    if (otherValue == null) {
      return false;
    }

    if (hour > otherValue.hour) {
      return true;
    }

    if (hour == otherValue.hour && minute > otherValue.minute) {
      return true;
    }

    return false;
  }

  TimeOfDay add({
    int? hours,
    int? minutes,
  }) {
    if (hours == null && minutes == null) {
      return this;
    }

    int newHour = hour;
    if (hours != null) {
      newHour += hours;
    }

    int newMinute = minute;
    if (minutes != null) {
      newMinute += minutes;
    }

    if (newMinute >= 60) {
      final extraHours = newMinute ~/ 60;
      newHour = newHour + extraHours;
      newMinute = newMinute % 60;
    }

    return TimeOfDay(
      hour: newHour,
      minute: newMinute,
    );
  }
}
