import '../../../../core/usecases/usecase.dart';
import '../entities/activity_entity.dart';
import '../entities/nutrition_activity_entity.dart';
import '../repositories/activity_repository.dart';

class GetNutritionUseCase extends UseCase<
    ActivityEntity<List<NutritionActivityEntity>>?, GetNutritionUseCaseParams> {
  final HealthRepository healthRepository;

  GetNutritionUseCase({
    required this.healthRepository,
  });

  @override
  Future<ActivityEntity<List<NutritionActivityEntity>>?> call(
      GetNutritionUseCaseParams params) async {
    try {
      return await healthRepository.getNutrition(
        startDate: params.startDate,
        endDate: params.endDate,
      );
    } catch (_) {
      rethrow;
    }
  }
}

class GetNutritionUseCaseParams {
  final DateTime? startDate;
  final DateTime? endDate;

  GetNutritionUseCaseParams({
    this.startDate,
    this.endDate,
  });
}
