import 'package:akasia365mc/core/ui/extensions/weight_goal_flag_extension.dart';
import 'package:equatable/equatable.dart';

import 'weight_goal_pacing_entity.dart';

class WeightGoalSimulationEntity extends Equatable {
  final double? startingWeight;
  final String? startingDate;
  final double? targetWeight;
  final String? activityLevel;
  final double? caloriesToMaintain;
  final WeightGoalFlag? flag;
  final List<WeightGoalPacingEntity>? pacing;

  const WeightGoalSimulationEntity({
    this.startingWeight,
    this.startingDate,
    this.targetWeight,
    this.activityLevel,
    this.caloriesToMaintain,
    this.flag,
    this.pacing,
  });

  @override
  List<Object?> get props => [
        startingWeight,
        startingDate,
        targetWeight,
        activityLevel,
        caloriesToMaintain,
        flag,
        pacing,
      ];
}
