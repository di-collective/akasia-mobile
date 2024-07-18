import '../entities/activity_entity.dart';
import '../entities/steps_activity_entity.dart';

abstract class HealthRepository {
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  });
}
