import '../entities/weight_goal_entity.dart';

abstract class WeightGoalRepository {
  Future<WeightGoalEntity> getWeightGoal();
}
