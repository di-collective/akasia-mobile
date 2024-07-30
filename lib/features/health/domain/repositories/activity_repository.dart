import '../entities/activity_entity.dart';
import '../entities/heart_rate_activity_entity.dart';
import '../entities/nutrition_activity_entity.dart';
import '../entities/sleep_activity_entity.dart';
import '../entities/steps_activity_entity.dart';
import '../entities/workout_activity_entity.dart';

abstract class HealthRepository {
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<SleepActivityEntity>>?> getSleep({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<HeartRateActivityEntity>>?> getHeartRate({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<WorkoutActivityEntity>>?> getWorkout({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<NutritionActivityEntity>>?> getNutrition({
    DateTime? startDate,
    DateTime? endDate,
  });
}
