part of 'sleep_cubit.dart';

sealed class SleepState extends Equatable {
  const SleepState();

  @override
  List<Object?> get props => [];
}

final class SleepInitial extends SleepState {}

final class SleepLoading extends SleepState {}

final class SleepLoaded extends SleepState {
  final ActivityEntity<List<SleepActivityEntity>>? sleep;

  const SleepLoaded({
    required this.sleep,
  });

  SleepLoaded copyWith({
    ActivityEntity<List<SleepActivityEntity>>? sleep,
  }) {
    return SleepLoaded(
      sleep: sleep ?? this.sleep,
    );
  }

  List<SleepActivityEntity>? getLastSevenData() {
    final List<SleepActivityEntity> result = [];

    final allData = sleep?.data ?? [];
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
  List<Object?> get props => [sleep];
}

final class SleepError extends SleepState {
  final Object error;

  const SleepError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
