import 'package:equatable/equatable.dart';

import '../../../../core/ui/extensions/weight_goal_flag_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';

class WeightGoalEntity extends Equatable {
  final double? startingWeight;
  final String? startingDate;
  final double? targetWeight;
  final String? targetDate;
  final String? activityLevel;
  final double? dailyCaloriesBudget;
  final double? caloriesToMaintain;
  final WeightGoalFlag? flag;
  final WeightGoalPace? pace;

  const WeightGoalEntity({
    this.startingWeight,
    this.startingDate,
    this.targetWeight,
    this.targetDate,
    this.activityLevel,
    this.dailyCaloriesBudget,
    this.caloriesToMaintain,
    this.flag,
    this.pace,
  });

  bool get isNull => this == const WeightGoalEntity();

  @override
  List<Object?> get props => [
        startingWeight,
        startingDate,
        targetWeight,
        targetDate,
        activityLevel,
        dailyCaloriesBudget,
        caloriesToMaintain,
        flag,
        pace,
      ];
}
