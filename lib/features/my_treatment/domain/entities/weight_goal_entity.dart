import 'package:equatable/equatable.dart';

class WeightGoalEntity extends Equatable {
  final double? startingWeight;
  final String? startingDate;
  final double? targetWeight;
  final String? targetDate;
  final String? activityLevel;
  final double? dailyCaloriesBudget;
  final double? caloriesToMaintain;
  final String? flag;
  final String? pace;

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
