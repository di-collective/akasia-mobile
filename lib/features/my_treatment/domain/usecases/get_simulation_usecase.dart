import '../../../../core/usecases/usecase.dart';
import '../entities/weight_goal_simulation_entity.dart';
import '../repositories/weight_goal_repository.dart';

class GetSimulationUseCase
    extends UseCase<WeightGoalSimulationEntity, GetSimulationUseCaseParams> {
  final WeightGoalRepository weightGoalRepository;

  GetSimulationUseCase({
    required this.weightGoalRepository,
  });

  @override
  Future<WeightGoalSimulationEntity> call(
      GetSimulationUseCaseParams params) async {
    return await weightGoalRepository.getSimulation(
      startingWeight: params.startingWeight,
      targetWeight: params.targetWeight,
      activityLevel: params.activityLevel,
    );
  }
}

class GetSimulationUseCaseParams {
  final double? startingWeight;
  final double? targetWeight;
  final String? activityLevel;

  GetSimulationUseCaseParams({
    required this.startingWeight,
    required this.targetWeight,
    required this.activityLevel,
  });
}
