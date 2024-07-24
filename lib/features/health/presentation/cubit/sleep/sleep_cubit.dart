import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/sleep_activity_entity.dart';
import '../../../domain/usecases/get_sleep_usecase.dart';

part 'sleep_state.dart';

class SleepCubit extends Cubit<SleepState> {
  final GetSleepUseCase getSleepUseCase;

  SleepCubit({
    required this.getSleepUseCase,
  }) : super(SleepInitial());

  Future<void> getSleepInOneWeek() async {
    try {
      emit(SleepLoading());

      final sleep = await getSleepUseCase.call(
        GetSleepUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      emit(SleepLoaded(
        sleep: sleep,
      ));
    } catch (error) {
      emit(SleepError(
        error: error,
      ));
    }
  }

  Future<void> getSleepAll() async {
    try {
      if (state is! SleepLoaded) {
        emit(SleepLoading());
      }

      final sleep = await getSleepUseCase.call(
        GetSleepUseCaseParams(),
      );

      emit(SleepLoaded(
        sleep: sleep,
      ));
    } catch (error) {
      if (state is! SleepLoaded) {
        emit(SleepError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  Future<void> refreshSleepInOneWeek() async {
    final currentState = state;

    try {
      if (currentState is! SleepLoaded) {
        emit(SleepLoading());
      }

      final newSleep = await getSleepUseCase.call(
        GetSleepUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      if (currentState is SleepLoaded) {
        // replace the data in current state if have same date
        final currentSleep = currentState.sleep;
        final currentData =
            List<SleepActivityEntity>.from(currentSleep?.data ?? []);
        if (currentData.isNotEmpty) {
          final newSleepData = currentSleep?.data;
          if (newSleepData != null && newSleepData.isNotEmpty) {
            for (final data in newSleepData) {
              final index = currentData.indexWhere(
                (element) {
                  return element.fromDate == data.fromDate;
                },
              );

              if (index != -1) {
                currentData[index] = data;
              } else {
                currentData.add(data);
              }
            }
          }
        }

        emit(SleepLoaded(
          sleep: ActivityEntity(
            createdAt: currentSleep?.createdAt,
            updatedAt: newSleep?.updatedAt,
            data: currentData,
          ),
        ));
      } else {
        emit(SleepLoaded(
          sleep: newSleep,
        ));
      }
    } catch (error) {
      if (currentState is! SleepLoaded) {
        emit(SleepError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
