import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/steps_activity_entity.dart';
import '../../../domain/usecases/get_steps_usecase.dart';

part 'steps_state.dart';

class StepsCubit extends Cubit<StepsState> {
  final GetStepsUseCase getStepsUseCase;

  StepsCubit({
    required this.getStepsUseCase,
  }) : super(StepsInitial());

  Future<void> getStepsInOneWeek() async {
    try {
      emit(StepsLoading());

      final steps = await getStepsUseCase.call(
        GetStepsUseCaseParams(
          startDate: DateTime.now().addDays(-6),
          endDate: DateTime.now(),
        ),
      );

      emit(StepsLoaded(
        steps: steps,
      ));
    } catch (error) {
      emit(StepsError(
        error: error,
      ));
    }
  }

  Future<void> refreshStepsInOneWeek() async {
    final currentState = state;

    try {
      if (currentState is! StepsLoaded) {
        emit(StepsLoading());
      }

      final newSteps = await getStepsUseCase.call(
        GetStepsUseCaseParams(
          startDate: DateTime.now().addDays(-6),
          endDate: DateTime.now(),
        ),
      );

      if (currentState is StepsLoaded) {
        // replace the data in current state if have same date
        final currentSteps = currentState.steps;
        final currentData =
            List<StepsActivityEntity>.from(currentSteps?.data ?? []);
        if (currentData.isNotEmpty) {
          final newStepsData = newSteps?.data;
          if (newStepsData != null && newStepsData.isNotEmpty) {
            for (final newStep in newStepsData) {
              final index = currentData.indexWhere(
                (element) {
                  return element.date?.isSameDay(other: newStep.date) ?? false;
                },
              );

              if (index != -1) {
                currentData[index] = newStep;
              } else {
                currentData.add(newStep);
              }
            }
          }
        }

        emit(StepsLoaded(
          steps: ActivityEntity(
            createdAt: currentSteps?.createdAt,
            updatedAt: newSteps?.updatedAt,
            data: currentData,
          ),
        ));
      } else {
        emit(StepsLoaded(
          steps: newSteps,
        ));
      }
    } catch (error) {
      if (currentState is! StepsLoaded) {
        emit(StepsError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
