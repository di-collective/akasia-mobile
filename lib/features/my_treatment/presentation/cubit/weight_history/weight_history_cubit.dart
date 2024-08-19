import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/weight_history_entity.dart';
import '../../../domain/usecases/update_weight_usecase.dart';

part 'weight_history_state.dart';

class WeightHistoryCubit extends Cubit<WeightHistoryState> {
  final UpdateWeightUseCase updateWeightUseCase;

  WeightHistoryCubit({
    required this.updateWeightUseCase,
  }) : super(WeightHistoryInitial());

  Future<void> updateWeight({
    required double? weight,
    required DateTime? date,
  }) async {
    final currentState = state;

    try {
      final result = await updateWeightUseCase(
        UpdateWeightUseCaseParams(
          weight: weight,
          date: date,
        ),
      );

      if (currentState is WeightHistoryLoaded) {
        final currentHistories = List<WeightHistoryEntity>.from(
          currentState.histories,
        );

        final index = currentHistories.indexWhere(
          (element) => element.date == date,
        );
        if (index != -1) {
          // Update the existing history
          currentHistories[index] = result;
        } else {
          // Add the new history
          currentHistories.add(result);
        }

        // update the state
        emit(currentState.copyWith(
          histories: currentHistories,
        ));
      } else {
        emit(WeightHistoryLoaded(
          histories: [result],
        ));
      }
    } catch (error) {
      if (currentState is! WeightHistoryLoaded) {
        emit(WeightHistoryError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
