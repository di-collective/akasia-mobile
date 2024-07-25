import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/workout_activity_entity.dart';
import '../../../domain/usecases/get_workout_usecase.dart';

part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final GetWorkoutUseCase getWorkoutUseCase;

  WorkoutCubit({
    required this.getWorkoutUseCase,
  }) : super(WorkoutInitial());

  Future<void> getWorkoutInOneWeek() async {
    try {
      emit(WorkoutLoading());

      final workout = await getWorkoutUseCase.call(
        GetWorkoutUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      emit(WorkoutLoaded(
        workout: workout,
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
      } else {
        emit(WorkoutLoaded(
          workout: newWorkout,
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
