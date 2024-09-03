import '../../../../core/usecases/usecase.dart';
import '../entities/weight_goal_entity.dart';
import '../repositories/weight_goal_repository.dart';

class GetWeightGoalUseCase extends UseCase<WeightGoalEntity, NoParams> {
  final WeightGoalRepository weightGoalRepository;

  GetWeightGoalUseCase({
    required this.weightGoalRepository,
  });

  @override
  Future<WeightGoalEntity> call(NoParams params) async {
    return await weightGoalRepository.getWeightGoal();
  }
}
