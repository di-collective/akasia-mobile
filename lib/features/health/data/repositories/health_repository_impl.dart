import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/steps_activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/health_local_datasource.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthLocalDataSource healthLocalDataSource;

  HealthRepositoryImpl({required this.healthLocalDataSource});

  @override
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await healthLocalDataSource.getSteps(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}
