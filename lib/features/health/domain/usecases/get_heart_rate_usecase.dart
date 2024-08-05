import '../../../../core/usecases/usecase.dart';
import '../entities/activity_entity.dart';
import '../entities/heart_rate_activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetHeartRateUseCase extends UseCase<
    ActivityEntity<List<HeartRateActivityEntity>>?, GetHeartRateUseCaseParams> {
  final HealthRepository healthRepository;

  GetHeartRateUseCase({
    required this.healthRepository,
  });

  @override
  Future<ActivityEntity<List<HeartRateActivityEntity>>?> call(
      GetHeartRateUseCaseParams params) async {
    try {
      return await healthRepository.getHeartRate(
        startDate: params.startDate,
        endDate: params.endDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}

class GetHeartRateUseCaseParams {
  final DateTime? startDate;
  final DateTime? endDate;

  GetHeartRateUseCaseParams({
    this.startDate,
    this.endDate,
  });
}
