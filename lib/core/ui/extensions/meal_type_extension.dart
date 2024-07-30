import 'package:akasia365mc/core/ui/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

import 'build_context_extension.dart';

extension MealTypeExtension on MealType {
  String title({
    required BuildContext context,
  }) {
    switch (this) {
      case MealType.BREAKFAST:
        return context.locale.breakfast;
      case MealType.LUNCH:
        return context.locale.lunch;
      case MealType.DINNER:
        return context.locale.dinner;
      case MealType.SNACK:
        return context.locale.snacks;
      case MealType.UNKNOWN:
        return context.locale.other;
    }
  }

  DateTime startTime({
    required DateTime date,
  }) {
    switch (this) {
      case MealType.BREAKFAST:
        return date.firstHourOfDay;
      case MealType.LUNCH:
        return date.firstHourOfDay.add(
          const Duration(
            hours: 10,
          ),
        );
      case MealType.DINNER:
        return date.firstHourOfDay.add(
          const Duration(
            hours: 15,
          ),
        );
      case MealType.SNACK:
        return date;
      case MealType.UNKNOWN:
        return date;
    }
  }

  DateTime endTime({
    required DateTime date,
  }) {
    switch (this) {
      case MealType.BREAKFAST:
        return date.firstHourOfDay.add(
          const Duration(
            hours: 10,
          ),
        );
      case MealType.LUNCH:
        return date.firstHourOfDay.add(
          const Duration(
            hours: 15,
          ),
        );
      case MealType.DINNER:
        return date.firstHourOfDay.add(
          const Duration(
            hours: 20,
          ),
        );
      case MealType.SNACK:
        return date.add(
          const Duration(
            hours: 1,
          ),
        );
      case MealType.UNKNOWN:
        return date.add(
          const Duration(
            hours: 1,
          ),
        );
    }
  }

  static List<MealType> get valuesWithoutUnknown {
    return [
      MealType.BREAKFAST,
      MealType.LUNCH,
      MealType.DINNER,
      MealType.SNACK,
    ];
  }
}
