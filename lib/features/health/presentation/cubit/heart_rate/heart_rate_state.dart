part of 'heart_rate_cubit.dart';

sealed class HeartRateState extends Equatable {
  const HeartRateState();

  @override
  List<Object?> get props => [];
}

final class HeartRateInitial extends HeartRateState {}

final class HeartRateLoading extends HeartRateState {}

final class HeartRateLoaded extends HeartRateState {
  final ActivityEntity<List<HeartRateActivityEntity>>? heartRate;

  const HeartRateLoaded({
    required this.heartRate,
  });

  HeartRateLoaded copyWith({
    ActivityEntity<List<HeartRateActivityEntity>>? heartRate,
  }) {
    return HeartRateLoaded(
      heartRate: heartRate ?? this.heartRate,
    );
  }

  List<HeartRateActivityEntity>? getLastSevenData() {
    final List<HeartRateActivityEntity> result = [];

    final allData = heartRate?.data ?? [];
    if (allData.isNotEmpty) {
      for (int i = 7; i >= 0; i--) {
        final lastOffset = allData.length - i;
        if (lastOffset >= 0) {
          if (allData.length > lastOffset) {
            result.add(allData[lastOffset]);
          }
          continue;
        }
      }
    }

    return result;
  }

  @override
  List<Object?> get props => [heartRate];
}

final class HeartRateError extends HeartRateState {
  final Object error;

  const HeartRateError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
