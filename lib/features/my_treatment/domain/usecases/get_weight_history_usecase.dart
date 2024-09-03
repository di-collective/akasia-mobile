import '../../../../core/usecases/usecase.dart';
import '../entities/weight_history_entity.dart';
import '../repositories/weight_goal_repository.dart';

class GetWeightHistoryUseCase
    extends UseCase<List<WeightHistoryEntity>, GetWeightHistoryUseCaseParams> {
  final WeightGoalRepository weightGoalRepository;

  GetWeightHistoryUseCase({
    required this.weightGoalRepository,
  });

  @override
  Future<List<WeightHistoryEntity>> call(
      GetWeightHistoryUseCaseParams params) async {
    return await weightGoalRepository.getWeightHistory(
      page: params.page,
      limit: params.limit,
      fromDate: params.fromDate,
      toDate: params.toDate,
    );
  }
}

class GetWeightHistoryUseCaseParams {
  final int? page;
  final int? limit;
  final DateTime? fromDate;
  final DateTime? toDate;

  GetWeightHistoryUseCaseParams({
    this.page,
    this.limit,
    this.fromDate,
    this.toDate,
  });
}
