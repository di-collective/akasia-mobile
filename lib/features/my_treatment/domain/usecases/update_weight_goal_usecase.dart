import '../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weight_goal_entity.dart';
import '../repositories/weight_goal_repository.dart';

class UpdateWeightGoalUseCase
    extends UseCase<WeightGoalEntity, UpdateWeightGoalUseCaseParams> {
  final WeightGoalRepository weightGoalRepository;

  UpdateWeightGoalUseCase({
    required this.weightGoalRepository,
  });

  @override
  Future<WeightGoalEntity> call(UpdateWeightGoalUseCaseParams params) async {
    return await weightGoalRepository.updateWeightGoal(
      startingDate: params.startingDate,
      startingWeight: params.startingWeight,
      targetWeight: params.targetWeight,
      activityLevel: params.activityLevel,
      pace: params.pace,
    );
  }
}

class UpdateWeightGoalUseCaseParams {
  final String? startingDate;
  final double? startingWeight;
  final double? targetWeight;
  final String? activityLevel;
  final WeightGoalPace? pace;

  UpdateWeightGoalUseCaseParams({
    required this.startingDate,
    required this.startingWeight,
    required this.targetWeight,
    required this.activityLevel,
    required this.pace,
  });
}
