import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/health_service.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/workout_activity_entity.dart';
import '../../../domain/usecases/get_workout_usecase.dart';

part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final GetWorkoutUseCase getWorkoutUseCase;
  final HealthService healthService;

  WorkoutCubit({
    required this.getWorkoutUseCase,
    required this.healthService,
  }) : super(WorkoutInitial()) {
    refreshIntervalDuration = healthService.refreshIntervalDuration;
  }

  late Duration refreshIntervalDuration;

  bool get isRefreshable {
    final currentState = state;
    if (currentState is! WorkoutLoaded) {
      return true;
    }

    final currentDate = DateTime.now();
    final updatedAt = currentState.workout?.updatedAt;
    // if updatedAt is less than refreshIntervalDuration, then return false
    if (updatedAt != null) {
      final diff = currentDate.difference(updatedAt);

      if (diff < refreshIntervalDuration) {
        // emit checkedAt
        emit(
          currentState.copyWith(
            checkedAt: currentDate,
          ),
        );

        return false;
      }
    }

    return true;
  }

  Future<void> getWorkoutInOneWeek() async {
    try {
      if (!isRefreshable) {
        return;
      }

      emit(WorkoutLoading());

      final workout = await getWorkoutUseCase.call(
        GetWorkoutUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      emit(WorkoutLoaded(
        workout: workout,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      emit(WorkoutError(
        error: error,
      ));
    }
  }

  Future<void> getWorkoutAll() async {
    try {
      if (state is! WorkoutLoaded) {
        emit(WorkoutLoading());
      }

      final workout = await getWorkoutUseCase.call(
        GetWorkoutUseCaseParams(),
      );

      emit(WorkoutLoaded(
        workout: workout,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      if (state is! WorkoutLoaded) {
        emit(WorkoutError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  Future<void> refreshWorkoutInOneWeek() async {
    final currentState = state;

    try {
      if (!isRefreshable) {
        return;
      }

      if (currentState is! WorkoutLoaded) {
        emit(WorkoutLoading());
      }

      final newWorkout = await getWorkoutUseCase.call(
        GetWorkoutUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      if (currentState is WorkoutLoaded) {
        // replace the data in current state if have same date
        final currentWorkout = currentState.workout;
        final currentData =
            List<WorkoutActivityEntity>.from(currentWorkout?.data ?? []);
        if (currentData.isNotEmpty) {
          final newWorkoutData = currentWorkout?.data;
          if (newWorkoutData != null && newWorkoutData.isNotEmpty) {
            for (final data in newWorkoutData) {
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

        emit(WorkoutLoaded(
          workout: ActivityEntity(
            createdAt: currentWorkout?.createdAt,
            updatedAt: newWorkout?.updatedAt,
            data: currentData,
          ),
          checkedAt: DateTime.now(),
        ));
      } else {
        emit(WorkoutLoaded(
          workout: newWorkout,
          checkedAt: DateTime.now(),
        ));
      }
    } catch (error) {
      if (currentState is! WorkoutLoaded) {
        emit(WorkoutError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
