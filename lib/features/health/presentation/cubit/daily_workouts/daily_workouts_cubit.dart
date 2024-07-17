import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_workouts_state.dart';

class DailyWorkoutsCubit extends Cubit<DailyWorkoutsState> {
  DailyWorkoutsCubit() : super(DailyWorkoutsInitial());

  Future<void> getDailyWorkouts() async {
    try {
      emit(DailyWorkoutsLoading());

      // TODO: Implement getDailyWorkouts
      final data = await Future.delayed(const Duration(seconds: 5)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyWorkoutsLoaded(
        data: data,
      ));
    } catch (error) {
      emit(DailyWorkoutsError(
        error: error,
      ));
    }
  }

  Future<void> refreshDailyWorkouts() async {
    final currentState = state;

    try {
      if (currentState is! DailyWorkoutsLoaded) {
        emit(DailyWorkoutsLoading());
      }

      // TODO: Implement getDailyWorkouts
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyWorkoutsLoaded(
        data: data,
      ));
    } catch (error) {
      if (currentState is! DailyWorkoutsLoaded) {
        emit(DailyWorkoutsError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
