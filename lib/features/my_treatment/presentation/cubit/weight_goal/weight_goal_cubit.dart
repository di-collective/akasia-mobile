import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/http/dio_interceptor.dart';
import '../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/weight_goal_entity.dart';
import '../../../domain/usecases/create_weight_goal_usecase.dart';
import '../../../domain/usecases/get_weight_goal_usecase.dart';

part 'weight_goal_state.dart';

class WeightGoalCubit extends Cubit<WeightGoalState> {
  final GetWeightGoalUseCase getWeightGoalUseCase;
  final CreateWeightGoalUseCase createWeightGoalUseCase;

  WeightGoalCubit({
    required this.getWeightGoalUseCase,
    required this.createWeightGoalUseCase,
  }) : super(WeightGoalInitial());

  Future<WeightGoalEntity?> getWeightGoal() async {
    try {
      emit(WeightGoalLoading());

      final weightGoal = await getWeightGoalUseCase.call(NoParams());

      emit(WeightGoalLoaded(weightGoal: weightGoal));

      return weightGoal;
    } catch (error) {
      if (error is NotFoundException) {
        // if the weight goal is not found, emit the state with null weight goal
        emit(const WeightGoalLoaded(
          weightGoal: null,
        ));

        return null;
      }

      emit(WeightGoalError(
        error: error,
      ));

      rethrow;
    }
  }

  Future<WeightGoalEntity> createWeightGoal({
    required String? startingWeight,
    required String? targetWeight,
    required WeightGoalActivityLevel? activityLevel,
    required WeightGoalPace? pace,
  }) async {
    try {
      final weightGoal = await createWeightGoalUseCase.call(
        CreateWeightGoalUseCaseParams(
          startingWeight: startingWeight?.parseToDouble,
          targetWeight: targetWeight?.parseToDouble,
          activityLevel: activityLevel?.title,
          pace: pace?.title,
        ),
      );

      emit(WeightGoalLoaded(
        weightGoal: weightGoal,
      ));

      return weightGoal;
    } catch (_) {
      rethrow;
    }
  }
}
