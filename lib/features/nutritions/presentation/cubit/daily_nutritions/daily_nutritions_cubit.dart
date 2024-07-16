import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_nutritions_state.dart';

class DailyNutritionsCubit extends Cubit<DailyNutritionsState> {
  DailyNutritionsCubit() : super(DailyNutritionsInitial());

  Future<void> getDailyNutritions() async {
    try {
      emit(DailyNutritionsLoading());

      // TODO: Implement getDailyNutritions
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyNutritionsLoaded(
        data: data,
      ));
    } catch (error) {
      emit(DailyNutritionsError(
        error: error,
      ));
    }
  }

  Future<void> refreshDailyNutritions() async {
    final currentState = state;

    try {
      if (currentState is! DailyNutritionsLoaded) {
        emit(DailyNutritionsLoading());
      }

      // TODO: Implement getDailyNutritions
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyNutritionsLoaded(
        data: data,
      ));
    } catch (error) {
      if (currentState is! DailyNutritionsLoaded) {
        emit(DailyNutritionsError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
