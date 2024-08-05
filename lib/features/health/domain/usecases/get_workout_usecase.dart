import '../../../../core/usecases/usecase.dart';
import '../entities/activity_entity.dart';
import '../entities/workout_activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetWorkoutUseCase extends UseCase<
    ActivityEntity<List<WorkoutActivityEntity>>?, GetWorkoutUseCaseParams> {
  final HealthRepository healthRepository;

  GetWorkoutUseCase({
    required this.healthRepository,
  });

  @override
  Future<ActivityEntity<List<WorkoutActivityEntity>>?> call(
      GetWorkoutUseCaseParams params) async {
    try {
      return await healthRepository.getWorkout(
        startDate: params.startDate,
        endDate: params.endDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}

class GetWorkoutUseCaseParams {
  final DateTime? startDate;
  final DateTime? endDate;

  GetWorkoutUseCaseParams({
    this.startDate,
    this.endDate,
  });
}
