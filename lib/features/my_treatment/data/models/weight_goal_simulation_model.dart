import 'package:akasia365mc/core/ui/extensions/weight_goal_flag_extension.dart';

import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../domain/entities/weight_goal_simulation_entity.dart';
import 'weight_goal_pacing_model.dart';

class WeightGoalSimulationModel extends WeightGoalSimulationEntity {
  const WeightGoalSimulationModel({
    super.startingWeight,
    super.startingDate,
    super.targetWeight,
    super.activityLevel,
    super.caloriesToMaintain,
    super.flag,
    super.pacing,
  });

  factory WeightGoalSimulationModel.fromJson(Map<String, dynamic> json) {
    return WeightGoalSimulationModel(
      startingWeight: DynamicExtension(
        json['starting_weight'],
      ).dynamicToDouble,
      startingDate: json['starting_date'],
      targetWeight: DynamicExtension(
        json['target_weight'],
      ).dynamicToDouble,
      activityLevel: json['activity_level'],
      caloriesToMaintain: DynamicExtension(
        json['calories_to_maintain'],
      ).dynamicToDouble,
      flag: WeightGoalFlagExtension.fromString(
        json['flag'],
      ),
      pacing: (json['pacing'] is List)
          ? (json['pacing'] as List).map((e) {
              return WeightGoalPacingModel.fromJson(e);
            }).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starting_weight': startingWeight,
      'starting_date': startingDate,
      'target_weight': targetWeight,
      'activity_level': activityLevel,
      'calories_to_maintain': caloriesToMaintain,
      'flag': flag,
      'pacing': pacing?.map((e) {
        return (e as WeightGoalPacingModel).toJson();
      }).toList(),
    };
  }
}
