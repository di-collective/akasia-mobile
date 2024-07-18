import '../../../../core/usecases/usecase.dart';
import '../entities/activity_entity.dart';
import '../entities/steps_activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetStepsUseCase extends UseCase<
    ActivityEntity<List<StepsActivityEntity>>?, GetStepsUseCaseParams> {
  final HealthRepository healthRepository;

  GetStepsUseCase({required this.healthRepository});

  @override
  Future<ActivityEntity<List<StepsActivityEntity>>?> call(
      GetStepsUseCaseParams params) async {
    try {
      return await healthRepository.getSteps(
        startDate: params.startDate,
        endDate: params.endDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}

class GetStepsUseCaseParams {
  final DateTime? startDate;
  final DateTime? endDate;

  GetStepsUseCaseParams({
    this.startDate,
    this.endDate,
  });
}
