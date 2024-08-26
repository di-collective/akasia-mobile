import 'package:akasia365mc/core/ui/extensions/string_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/weight_history_entity.dart';
import '../../../domain/usecases/get_weight_history_usecase.dart';
import '../../../domain/usecases/update_weight_usecase.dart';

part 'weight_history_state.dart';

class WeightHistoryCubit extends Cubit<WeightHistoryState> {
  final GetWeightHistoryUseCase getWeightHistoryUseCase;
  final UpdateWeightUseCase updateWeightUseCase;

  WeightHistoryCubit({
    required this.getWeightHistoryUseCase,
    required this.updateWeightUseCase,
  }) : super(WeightHistoryInitial());

  Future<void> getWeightHistory({
    int? page,
    int? limit,
    String? fromDate,
    String? toDate,
  }) async {
    final currentState = state;
    if (currentState is WeightHistoryLoading) {
      return;
    }

    try {
      emit(WeightHistoryLoading());

      final result = await getWeightHistoryUseCase(
        GetWeightHistoryUseCaseParams(
          page: page,
          limit: limit,
          fromDate: fromDate?.toDateTime(),
          toDate: toDate?.toDateTime(),
        ),
      );

      emit(WeightHistoryLoaded(
        weights: result,
      ));
    } catch (error) {
      emit(WeightHistoryError(
        error: error,
      ));

      rethrow;
    }
  }

  Future<void> refreshWeightHistory({
    int? page,
    int? limit,
    String? fromDate,
    String? toDate,
  }) async {
    final currentState = state;
    if (currentState is WeightHistoryLoading) {
      return;
    }

    try {
      final result = await getWeightHistoryUseCase(
        GetWeightHistoryUseCaseParams(
          page: page,
          limit: limit,
          fromDate: fromDate?.toDateTime(),
          toDate: toDate?.toDateTime(),
        ),
      );

      emit(WeightHistoryLoaded(
        weights: result,
      ));
    } catch (error) {
      if (currentState is! WeightHistoryLoaded) {
        emit(WeightHistoryError(
          error: error,
        ));
      }

      rethrow;
    }
  }

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

      // Update the loaded data
      emitUpdateLoadedData(
        newWeight: result,
      );
    } catch (error) {
      if (currentState is! WeightHistoryLoaded) {
        emit(WeightHistoryError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  void emitUpdateLoadedData({
    required WeightHistoryEntity newWeight,
  }) {
    final currentState = state;
    if (currentState is WeightHistoryLoaded) {
      final currentHistories = List<WeightHistoryEntity>.from(
        currentState.weights,
      );

      final index = currentHistories.indexWhere(
        (element) => element.date == newWeight.date,
      );
      if (index != -1) {
        // Update the existing history
        currentHistories[index] = newWeight;
      } else {
        // Add the new history to first index
        currentHistories.insert(0, newWeight);
      }

      // update the state
      emit(currentState.copyWith(
        weights: currentHistories,
      ));
    } else {
      emit(WeightHistoryLoaded(
        weights: [newWeight],
      ));
    }
  }
}
