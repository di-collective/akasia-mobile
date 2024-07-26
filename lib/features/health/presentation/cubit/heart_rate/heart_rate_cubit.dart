import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/health_service.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/heart_rate_activity_entity.dart';
import '../../../domain/usecases/get_heart_rate_usecase.dart';

part 'heart_rate_state.dart';

class HeartRateCubit extends Cubit<HeartRateState> {
  final GetHeartRateUseCase getHeartRateUseCase;
  final HealthService healthService;

  HeartRateCubit({
    required this.getHeartRateUseCase,
    required this.healthService,
  }) : super(HeartRateInitial()) {
    refreshIntervalDuration = healthService.refreshIntervalDuration;
  }

  late Duration refreshIntervalDuration;

  bool get isRefreshable {
    final currentState = state;
    if (currentState is! HeartRateLoaded) {
      return true;
    }

    final currentDate = DateTime.now();
    final updatedAt = currentState.heartRate?.updatedAt;
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

  Future<void> getHeartRateInOneWeek() async {
    try {
      if (!isRefreshable) {
        return;
      }

      emit(HeartRateLoading());

      final heartRate = await getHeartRateUseCase.call(
        GetHeartRateUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      emit(HeartRateLoaded(
        heartRate: heartRate,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      emit(HeartRateError(
        error: error,
      ));
    }
  }

  Future<void> getHeartRateAll() async {
    try {
      if (state is! HeartRateLoaded) {
        emit(HeartRateLoading());
      }

      final heartRate = await getHeartRateUseCase.call(
        GetHeartRateUseCaseParams(),
      );

      emit(HeartRateLoaded(
        heartRate: heartRate,
        checkedAt: DateTime.now(),
      ));
    } catch (error) {
      if (state is! HeartRateLoaded) {
        emit(HeartRateError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  Future<void> refreshHeartRateInOneWeek() async {
    final currentState = state;

    try {
      if (!isRefreshable) {
        return;
      }

      if (currentState is! HeartRateLoaded) {
        emit(HeartRateLoading());
      }

      final newHeartRate = await getHeartRateUseCase.call(
        GetHeartRateUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      if (currentState is HeartRateLoaded) {
        // replace the data in current state if have same date
        final currentHearRate = currentState.heartRate;
        final currentData =
            List<HeartRateActivityEntity>.from(currentHearRate?.data ?? []);
        if (currentData.isNotEmpty) {
          final newHeartRateData = currentHearRate?.data;
          if (newHeartRateData != null && newHeartRateData.isNotEmpty) {
            for (final data in newHeartRateData) {
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

        emit(HeartRateLoaded(
          heartRate: ActivityEntity(
            createdAt: currentHearRate?.createdAt,
            updatedAt: newHeartRate?.updatedAt,
            data: currentData,
          ),
          checkedAt: DateTime.now(),
        ));
      } else {
        emit(HeartRateLoaded(
          heartRate: newHeartRate,
          checkedAt: DateTime.now(),
        ));
      }
    } catch (error) {
      if (currentState is! HeartRateLoaded) {
        emit(HeartRateError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
