import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../entities/weight_goal_entity.dart';
import '../entities/weight_goal_simulation_entity.dart';
import '../entities/weight_history_entity.dart';

abstract class WeightGoalRepository {
  Future<WeightGoalEntity> getWeightGoal();
  Future<WeightGoalEntity> createWeightGoal({
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
    required String? pace,
  });
  Future<WeightGoalSimulationEntity> getSimulation({
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
  });
  Future<WeightHistoryEntity> updateWeight({
    required double? weight,
    required DateTime? date,
  });
  Future<WeightGoalEntity> updateWeightGoal({
    required String? startingDate,
    required double? startingWeight,
    required double? targetWeight,
    required String? activityLevel,
    required WeightGoalPace? pace,
  });
}
