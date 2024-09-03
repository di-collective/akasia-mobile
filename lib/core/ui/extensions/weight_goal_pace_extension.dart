import 'package:akasia365mc/core/ui/extensions/weight_goal_flag_extension.dart';
import 'package:collection/collection.dart';

import 'string_extension.dart';

enum WeightGoalPace {
  relaxed,
  normal,
  strict,
}

extension WeightGoalPaceExtension on WeightGoalPace {
  String get titleApi {
    switch (this) {
      case WeightGoalPace.relaxed:
        return "Relaxed";
      case WeightGoalPace.normal:
        return "Normal";
      case WeightGoalPace.strict:
        return "Strict";
    }
  }

  String title({
    required WeightGoalFlag? flag,
  }) {
    switch (this) {
      case WeightGoalPace.relaxed:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "Relaxed";
          case WeightGoalFlag.gain:
            return "Gentle";
          default:
            return "Relaxed";
        }
      case WeightGoalPace.normal:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "Normal";
          case WeightGoalFlag.gain:
            return "Balanced";
          default:
            return "Normal";
        }
      case WeightGoalPace.strict:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "Strict";
          case WeightGoalFlag.gain:
            return "Accelerated";
          default:
            return "Strict";
        }
    }
  }

  String description({
    required WeightGoalFlag? flag,
  }) {
    switch (this) {
      case WeightGoalPace.relaxed:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "Fit sustainable weight loss into your lifestyle with our most lenient plan";
          case WeightGoalFlag.gain:
            return "Gain weight each week with this comfortable yet effective plan";
          default:
            return "Fit sustainable weight loss into your lifestyle with our most lenient plan";
        }

      case WeightGoalPace.normal:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "Lose weight each week with this comfortable yet effective plan";
          case WeightGoalFlag.gain:
            return "Lose weight each week with this comfortable yet effective plan";
          default:
            return "Lose weight each week with this comfortable yet effective plan";
        }
      case WeightGoalPace.strict:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "Lose weight more quickly with our most difficult plan";
          case WeightGoalFlag.gain:
            return "Pursue faster weight gain with a focused plan";
          default:
            return "Lose weight more quickly with our most difficult plan";
        }
    }
  }

  String losePerWeek({
    required WeightGoalFlag? flag,
  }) {
    switch (this) {
      case WeightGoalPace.relaxed:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "1/4 kg";
          case WeightGoalFlag.gain:
            return "1/8 kg";
          default:
            return "1/4 kg";
        }
      case WeightGoalPace.normal:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "1/2 kg";
          case WeightGoalFlag.gain:
            return "1/4 kg";
          default:
            return "1/2 kg";
        }
      case WeightGoalPace.strict:
        switch (flag) {
          case WeightGoalFlag.loss:
            return "1 kg";
          case WeightGoalFlag.gain:
            return "1/2 kg";
          default:
            return "1 kg";
        }
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
