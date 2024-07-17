import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'daily_steps_state.dart';

class DailyStepsCubit extends Cubit<DailyStepsState> {
  DailyStepsCubit() : super(DailyStepsInitial());

  Future<void> getDailySteps() async {
    try {
      emit(DailyStepsLoading());

      // TODO: Implement getDailySteps
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyStepsLoaded(
        data: data,
      ));
    } catch (error) {
      emit(DailyStepsError(
        error: error,
      ));
    }
  }

  Future<void> refreshDailySteps() async {
    final currentState = state;

    try {
      if (currentState is! DailyStepsLoaded) {
        emit(DailyStepsLoading());
      }

      // TODO: Implement getDailySteps
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyStepsLoaded(
        data: data,
      ));
    } catch (error) {
      if (currentState is! DailyStepsLoaded) {
        emit(DailyStepsError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
