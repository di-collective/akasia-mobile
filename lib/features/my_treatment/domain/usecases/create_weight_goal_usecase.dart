import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weight_goal_entity.dart';
import '../repositories/weight_goal_repository.dart';

class CreateWeightGoalUseCase
    extends UseCase<WeightGoalEntity, CreateWeightGoalUseCaseParams> {
  final WeightGoalRepository weightGoalRepository;

  CreateWeightGoalUseCase({
    required this.weightGoalRepository,
  });

  @override
  Future<WeightGoalEntity> call(CreateWeightGoalUseCaseParams params) async {
    return await weightGoalRepository.createWeightGoal(
      startingWeight: params.startingWeight,
      targetWeight: params.targetWeight,
      activityLevel: params.activityLevel,
      pace: params.pace,
    );
  }
}

class CreateWeightGoalUseCaseParams {
  final double? startingWeight;
  final double? targetWeight;
  final String? activityLevel;
  final WeightGoalPace? pace;

  CreateWeightGoalUseCaseParams({
    required this.startingWeight,
    required this.targetWeight,
    required this.activityLevel,
    required this.pace,
  });
}
