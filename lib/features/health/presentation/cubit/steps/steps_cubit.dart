import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/health_service.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/steps_activity_entity.dart';
import '../../../domain/usecases/get_steps_usecase.dart';

part 'steps_state.dart';

class StepsCubit extends Cubit<StepsState> {
  final GetStepsUseCase getStepsUseCase;
  final HealthService healthService;

  StepsCubit({
    required this.getStepsUseCase,
    required this.healthService,
  }) : super(StepsInitial()) {
    refreshIntervalDuration = healthService.refreshIntervalDuration;
  }

  late Duration refreshIntervalDuration;

  bool get isRefreshable {
    final currentState = state;
    if (currentState is! StepsLoaded) {
      return true;
    }

    final currentDate = DateTime.now();
    final updatedAt = currentState.steps?.updatedAt;
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

  Future<void> getStepsInOneWeek() async {
    try {
      if (!isRefreshable) {
        return;
      }

      emit(StepsLoading());

      final steps = await getStepsUseCase.call(
        GetStepsUseCaseParams(
          startDate: DateTime.now().addDays(-6),
          endDate: DateTime.now(),
        ),
      );

      emit(StepsLoaded(
        steps: steps,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      emit(StepsError(
        error: error,
      ));
    }
  }

  Future<void> getStepsAll() async {
    try {
      if (state is! StepsLoaded) {
        emit(StepsLoading());
      }

      final steps = await getStepsUseCase.call(
        GetStepsUseCaseParams(),
      );

      emit(StepsLoaded(
        steps: steps,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      if (state is! StepsLoaded) {
        emit(StepsError(
          error: error,
        ));
      }
    }
  }

  Future<void> refreshStepsInOneWeek() async {
    final currentState = state;

    try {
      if (!isRefreshable) {
        return;
      }

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
          checkedAt: DateTime.now(),
        ));
      } else {
        emit(StepsLoaded(
          steps: newSteps,
          checkedAt: DateTime.now(),
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
