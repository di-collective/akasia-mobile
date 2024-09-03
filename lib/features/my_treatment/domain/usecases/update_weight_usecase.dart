import '../../../../core/usecases/usecase.dart';
import '../entities/weight_history_entity.dart';
import '../repositories/weight_goal_repository.dart';

class UpdateWeightUseCase
    extends UseCase<WeightHistoryEntity, UpdateWeightUseCaseParams> {
  final WeightGoalRepository weightGoalRepository;

  UpdateWeightUseCase({
    required this.weightGoalRepository,
  });

  @override
  Future<WeightHistoryEntity> call(UpdateWeightUseCaseParams params) async {
    return await weightGoalRepository.updateWeight(
      weight: params.weight,
      date: params.date,
    );
  }
}

class UpdateWeightUseCaseParams {
  final double? weight;
  final DateTime? date;

  UpdateWeightUseCaseParams({
    required this.weight,
    required this.date,
  });
}
