import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../domain/entities/weight_goal_simulation_entity.dart';
import '../../../domain/usecases/get_simulation_usecase.dart';

part 'simulation_state.dart';

class SimulationCubit extends Cubit<SimulationState> {
  final GetSimulationUseCase getSimulationUseCase;

  SimulationCubit({
    required this.getSimulationUseCase,
  }) : super(SimulationInitial());

  Future<void> getSimulation({
    required String? startingWeight,
    required String? targetWeight,
    required WeightGoalActivityLevel? activityLevel,
  }) async {
    try {
      emit(SimulationLoading());

      final simulation = await getSimulationUseCase.call(
        GetSimulationUseCaseParams(
          startingWeight: startingWeight?.parseToDouble,
          targetWeight: targetWeight?.parseToDouble,
          activityLevel: activityLevel?.title,
        ),
      );

      emit(SimulationLoaded(simulation: simulation));
    } catch (error) {
      emit(SimulationError(error: error));

      rethrow;
    }
  }
}
