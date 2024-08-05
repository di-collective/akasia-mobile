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
  final DateTime? checkedAt;

  const HeartRateLoaded({
    required this.heartRate,
    required this.checkedAt,
  });

  HeartRateLoaded copyWith({
    ActivityEntity<List<HeartRateActivityEntity>>? heartRate,
    DateTime? checkedAt,
  }) {
    return HeartRateLoaded(
      heartRate: heartRate ?? this.heartRate,
      checkedAt: checkedAt ?? this.checkedAt,
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

  Map<DateTime, List<HeartRateActivityEntity>> getCurrentWeekData() {
    final Map<DateTime, List<HeartRateActivityEntity>> result = {};
    final allData = heartRate?.data ?? [];

    final currentDate = DateTime.now().firstHourOfDay;
    final firstDate = currentDate.firstDayOfTheWeek;
    // get date from first day of the week
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final date = firstDate.addDays(i);

      final data = allData.where((element) {
        return element.fromDate?.isSameDay(other: date) ?? false;
      });

      result.addAll({
        date: data.toList(),
      });
    }

    return result;
  }

  @override
  List<Object?> get props => [
        heartRate,
        checkedAt,
      ];
}

final class HeartRateError extends HeartRateState {
  final Object error;

  const HeartRateError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
