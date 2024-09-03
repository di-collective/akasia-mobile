import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../domain/entities/weight_goal_pacing_entity.dart';

class WeightGoalPacingModel extends WeightGoalPacingEntity {
  const WeightGoalPacingModel({
    super.pace,
    super.dailyCaloriesBudget,
    super.targetDate,
  });

  factory WeightGoalPacingModel.fromJson(Map<String, dynamic> json) {
    return WeightGoalPacingModel(
      pace: WeightGoalPaceExtension.fromString(
        json['pace'],
      ),
      dailyCaloriesBudget: DynamicExtension(
        json['daily_calories_budget'],
      ).dynamicToDouble,
      targetDate: json['target_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pace': pace,
      'daily_calories_budget': dailyCaloriesBudget,
      'target_date': targetDate,
    };
  }
}
