import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/http/dio_interceptor.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/weight_goal_entity.dart';
import '../../../domain/usecases/get_weight_goal_usecase.dart';

part 'weight_goal_state.dart';

class WeightGoalCubit extends Cubit<WeightGoalState> {
  final GetWeightGoalUseCase getWeightGoalUseCase;

  WeightGoalCubit({
    required this.getWeightGoalUseCase,
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
}
