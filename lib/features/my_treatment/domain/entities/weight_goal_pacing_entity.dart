import 'package:equatable/equatable.dart';

import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';

class WeightGoalPacingEntity extends Equatable {
  final WeightGoalPace? pace;
  final double? dailyCaloriesBudget;
  final String? targetDate;

  const WeightGoalPacingEntity({
    this.pace,
    this.dailyCaloriesBudget,
    this.targetDate,
  });

  @override
  List<Object?> get props => [
        pace,
        dailyCaloriesBudget,
        targetDate,
      ];
}
