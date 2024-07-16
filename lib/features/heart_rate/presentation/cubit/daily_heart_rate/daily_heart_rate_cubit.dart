import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'daily_heart_rate_state.dart';

class DailyHeartRateCubit extends Cubit<DailyHeartRateState> {
  DailyHeartRateCubit() : super(DailyHeartRateInitial());

  Future<void> getDailyHeartRate() async {
    try {
      emit(DailyHeartRateLoading());

      // TODO: Implement getDailyHeartRate
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyHeartRateLoaded(
        data: data,
      ));
    } catch (error) {
      emit(DailyHeartRateError(
        error: error,
      ));
    }
  }

  Future<void> refreshDailyHeartRate() async {
    final currentState = state;

    try {
      if (currentState is! DailyHeartRateLoaded) {
        emit(DailyHeartRateLoading());
      }

      // TODO: Implement getDailyHeartRate
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailyHeartRateLoaded(
        data: data,
      ));
    } catch (error) {
      if (currentState is! DailyHeartRateLoaded) {
        emit(DailyHeartRateError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
