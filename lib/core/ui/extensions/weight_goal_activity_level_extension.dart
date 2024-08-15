import 'package:collection/collection.dart';

import 'string_extension.dart';

enum WeightGoalActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
}

extension WeightGoalActivityLevelExtension on WeightGoalActivityLevel {
  String get title {
    switch (this) {
      case WeightGoalActivityLevel.sedentary:
        return "Sedentary";
      case WeightGoalActivityLevel.lightlyActive:
        return "Lightly Active";
      case WeightGoalActivityLevel.moderatelyActive:
        return "Moderately Active";
      case WeightGoalActivityLevel.veryActive:
        return "Very Active";
    }
  }

  String get description {
    switch (this) {
      case WeightGoalActivityLevel.sedentary:
        return "I sit at my desk all day";
      case WeightGoalActivityLevel.lightlyActive:
        return "I occasionaly exercise or walk for 30 minutes";
      case WeightGoalActivityLevel.moderatelyActive:
        return "I spend an hour or more working out everyday";
      case WeightGoalActivityLevel.veryActive:
        return "I love working out, and want to get more exercise";
    }
  }

  static WeightGoalActivityLevel? fromString(String? value) {
    if (value == null) {
      return null;
    }

    return WeightGoalActivityLevel.values.firstWhereOrNull(
      (element) => element.name.isSame(
        otherValue: value,
      ),
    );
  }
}
