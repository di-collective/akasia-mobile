import 'package:collection/collection.dart';

import 'string_extension.dart';

enum WeightGoalPace {
  relaxed,
  normal,
  strict,
}

extension WeightGoalPaceExtension on WeightGoalPace {
  String get title {
    switch (this) {
      case WeightGoalPace.relaxed:
        return "Relaxed";
      case WeightGoalPace.normal:
        return "Normal";
      case WeightGoalPace.strict:
        return "Strict";
    }
  }

  String get description {
    switch (this) {
      case WeightGoalPace.relaxed:
        return "Fit sustainable weight loss into your lifestyle with our most lenient plan";
      case WeightGoalPace.normal:
        return "Lose weight each week with this comfortable yet effective plan";
      case WeightGoalPace.strict:
        return "Lose weight more quickly with our most difficult plan";
    }
  }

  String get losePerWeek {
    switch (this) {
      case WeightGoalPace.relaxed:
        return "1/4kg";
      case WeightGoalPace.normal:
        return "1/2kg";
      case WeightGoalPace.strict:
        return "1kg";
    }
  }

  String get eatCaloriesPerDay {
    switch (this) {
      case WeightGoalPace.relaxed:
        return "1.4876";
      case WeightGoalPace.normal:
        return "1.4876";
      case WeightGoalPace.strict:
        return "1.4876";
    }
  }

  String get weeksToReachGoal {
    switch (this) {
      case WeightGoalPace.relaxed:
        return "20-22";
      case WeightGoalPace.normal:
        return "20-22";
      case WeightGoalPace.strict:
        return "20-22";
    }
  }

  bool get isRecommended {
    switch (this) {
      case WeightGoalPace.relaxed:
        return true;
      case WeightGoalPace.normal:
        return false;
      case WeightGoalPace.strict:
        return false;
    }
  }

  static WeightGoalPace? fromString(String? value) {
    if (value == null) {
      return null;
    }

    return WeightGoalPace.values.firstWhereOrNull(
      (element) => element.name.isSame(
        otherValue: value,
      ),
    );
  }
}
