import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/heart_rate_activity_entity.dart';
import '../../../domain/usecases/get_heart_rate_usecase.dart';

part 'heart_rate_state.dart';

class HeartRateCubit extends Cubit<HeartRateState> {
  final GetHeartRateUseCase getHeartRateUseCase;

  HeartRateCubit({
    required this.getHeartRateUseCase,
  }) : super(HeartRateInitial());

  Future<void> getHeartRateInOneWeek() async {
    try {
      emit(HeartRateLoading());

      final heartRate = await getHeartRateUseCase.call(
        GetHeartRateUseCaseParams(
          startDate: DateTime.now().add(const Duration(days: -6)),
          endDate: DateTime.now(),
        ),
      );

      emit(HeartRateLoaded(
        heartRate: heartRate,
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
        ));
      } else {
        emit(HeartRateLoaded(
          heartRate: newHeartRate,
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
