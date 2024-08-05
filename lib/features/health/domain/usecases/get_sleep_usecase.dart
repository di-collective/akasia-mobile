import '../../../../core/usecases/usecase.dart';
import '../entities/activity_entity.dart';
import '../entities/sleep_activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetSleepUseCase extends UseCase<
    ActivityEntity<List<SleepActivityEntity>>?, GetSleepUseCaseParams> {
  final HealthRepository healthRepository;

  GetSleepUseCase({
    required this.healthRepository,
  });

  @override
  Future<ActivityEntity<List<SleepActivityEntity>>?> call(
      GetSleepUseCaseParams params) async {
    try {
      return await healthRepository.getSleep(
        startDate: params.startDate,
        endDate: params.endDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}

class GetSleepUseCaseParams {
  final DateTime? startDate;
  final DateTime? endDate;

  GetSleepUseCaseParams({
    this.startDate,
    this.endDate,
  });
}
