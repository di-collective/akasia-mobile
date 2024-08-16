import '../entities/weight_goal_entity.dart';
import '../entities/weight_goal_simulation_entity.dart';

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
}
