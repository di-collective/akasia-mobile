import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../core/ui/extensions/weight_goal_flag_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../domain/entities/weight_goal_entity.dart';

class WeightGoalModel extends WeightGoalEntity {
  const WeightGoalModel({
    super.startingWeight,
    super.startingDate,
    super.targetWeight,
    super.targetDate,
    super.activityLevel,
    super.dailyCaloriesBudget,
    super.caloriesToMaintain,
    super.flag,
    super.pace,
  });

  factory WeightGoalModel.fromJson(Map<String, dynamic> json) {
    return WeightGoalModel(
      startingWeight: DynamicExtension(
        json['starting_weight'],
      ).dynamicToDouble,
      startingDate: json['starting_date'],
      targetWeight: DynamicExtension(
        json['target_weight'],
      ).dynamicToDouble,
      targetDate: json['target_date'],
      activityLevel: WeightGoalActivityLevelExtension.fromString(
        json['activity_level'],
      ),
      dailyCaloriesBudget: DynamicExtension(
        json['daily_calories_budget'],
      ).dynamicToDouble,
      caloriesToMaintain: DynamicExtension(
        json['calories_to_maintain'],
      ).dynamicToDouble,
      flag: WeightGoalFlagExtension.fromString(
        json['flag'],
      ),
      pace: WeightGoalPaceExtension.fromString(
        json['pace'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startingWeight': startingWeight,
      'startingDate': startingDate,
      'targetWeight': targetWeight,
      'targetDate': targetDate,
      'activityLevel': activityLevel,
      'dailyCaloriesBudget': dailyCaloriesBudget,
      'caloriesToMaintain': caloriesToMaintain,
      'flag': flag,
      'pace': pace,
    };
  }
}
