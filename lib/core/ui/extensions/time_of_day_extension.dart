import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get toTimeMinute {
    String parseMinute = minute.toString();
    if (parseMinute.length == 1) {
      parseMinute = '0$parseMinute';
    }

    return '$hour:$parseMinute';
  }
}
