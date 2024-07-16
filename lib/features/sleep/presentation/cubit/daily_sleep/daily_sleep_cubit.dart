import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'daily_sleep_state.dart';

class DailySleepCubit extends Cubit<DailySleepState> {
  DailySleepCubit() : super(DailySleepInitial());

  Future<void> getDailySleep() async {
    try {
      emit(DailySleepLoading());

      // TODO: Implement getDailySleep
      final data = await Future.delayed(const Duration(seconds: 3)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailySleepLoaded(
        data: data,
      ));
    } catch (error) {
      emit(DailySleepError(
        error: error,
      ));
    }
  }

  Future<void> refreshDailySleep() async {
    final currentState = state;

    try {
      if (currentState is! DailySleepLoaded) {
        emit(DailySleepLoading());
      }

      // TODO: Implement getDailySleep
      final data = await Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          return List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          );
        },
      );

      emit(DailySleepLoaded(
        data: data,
      ));
    } catch (error) {
      if (currentState is! DailySleepLoaded) {
        emit(DailySleepError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
