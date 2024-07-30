import 'dart:math';

import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/nutrition_activity_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'nutrition_state.dart';

class NutritionCubit extends Cubit<NutritionState> {
  NutritionCubit() : super(NutritionInitial());

  Future<void> getDailyNutritions() async {
    try {
      emit(NutritionLoading());

      // TODO: Implement getDailyNutritions
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );
    } catch (error) {
      emit(NutritionError(
        error: error,
      ));
    }
  }

  Future<void> getNutritionAll() async {
    // try {
    //   if (state is! SleepLoaded) {
    //     emit(SleepLoading());
    //   }

    //   final sleep = await getSleepUseCase.call(
    //     GetSleepUseCaseParams(),
    //   );

    //   emit(SleepLoaded(
    //     sleep: sleep,
    //     checkedAt: DateTime.now(),
    //   ));
    // } catch (error) {
    //   if (state is! SleepLoaded) {
    //     emit(SleepError(
    //       error: error,
    //     ));
    //   }

    //   rethrow;
    // }
  }

  Future<void> refreshDailyNutritions() async {
    final currentState = state;

    try {
      if (currentState is! NutritionLoaded) {
        emit(NutritionLoading());
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
    } catch (error) {
      if (currentState is! NutritionLoaded) {
        emit(NutritionError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
