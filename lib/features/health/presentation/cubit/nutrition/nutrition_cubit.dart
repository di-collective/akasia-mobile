import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/health_service.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/nutrition_activity_entity.dart';
import '../../../domain/usecases/get_nutrition_usecase.dart';

part 'nutrition_state.dart';

class NutritionCubit extends Cubit<NutritionState> {
  final GetNutritionUseCase getNutritionUseCase;
  final HealthService healthService;

  NutritionCubit({
    required this.getNutritionUseCase,
    required this.healthService,
  }) : super(NutritionInitial()) {
    refreshIntervalDuration = healthService.refreshIntervalDuration;
  }

  late Duration refreshIntervalDuration;

  bool get isRefreshable {
    final currentState = state;
    if (currentState is! NutritionLoaded) {
      return true;
    }

    final currentDate = DateTime.now();
    final updatedAt = currentState.nutritions?.updatedAt;
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

  Future<void> getNutritionInOneWeek() async {
    try {
      if (!isRefreshable) {
        return;
      }

      emit(NutritionLoading());

      final currentDate = DateTime.now();

      final nutritions = await getNutritionUseCase.call(
        GetNutritionUseCaseParams(
          startDate: currentDate.add(const Duration(days: -6)),
          endDate: currentDate,
        ),
      );

      emit(NutritionLoaded(
        nutritions: nutritions,
        checkedAt: currentDate,
      ));
    } catch (error) {
      emit(NutritionError(
        error: error,
      ));
    }
  }

  Future<void> getNutritionAll() async {
    try {
      if (state is! NutritionLoaded) {
        emit(NutritionLoading());
      }

      final nutritions = await getNutritionUseCase.call(
        GetNutritionUseCaseParams(),
      );

      emit(NutritionLoaded(
        nutritions: nutritions,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      if (state is! NutritionLoaded) {
        emit(NutritionError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  Future<void> refreshNutritionInOneWeek() async {
    final currentState = state;

    try {
      if (!isRefreshable) {
        return;
      }

      if (currentState is! NutritionLoaded) {
        emit(NutritionLoading());
      }

      final currentDate = DateTime.now();

      final newNutritions = await getNutritionUseCase.call(
        GetNutritionUseCaseParams(
          startDate: currentDate.add(const Duration(days: -6)),
          endDate: currentDate,
        ),
      );

      if (currentState is NutritionLoaded) {
        // replace the data in current state if have same date
        final currentNutritions = currentState.nutritions;
        final currentData =
            List<NutritionActivityEntity>.from(currentNutritions?.data ?? []);
        if (currentData.isNotEmpty) {
          final newSleepData = currentNutritions?.data;
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

        emit(NutritionLoaded(
          nutritions: ActivityEntity(
            createdAt: currentNutritions?.createdAt,
            updatedAt: newNutritions?.updatedAt,
            data: currentData,
          ),
          checkedAt: currentDate,
        ));
      } else {
        emit(NutritionLoaded(
          nutritions: newNutritions,
          checkedAt: currentDate,
        ));
      }
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
