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
  final DateTime? checkedAt;

  const SleepLoaded({
    required this.sleep,
    required this.checkedAt,
  });

  SleepLoaded copyWith({
    ActivityEntity<List<SleepActivityEntity>>? sleep,
    DateTime? checkedAt,
  }) {
    return SleepLoaded(
      sleep: sleep ?? this.sleep,
      checkedAt: checkedAt ?? this.checkedAt,
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

  Map<DateTime, List<SleepActivityEntity>> getCurrentWeekData() {
    final Map<DateTime, List<SleepActivityEntity>> result = {};
    final allData = sleep?.data ?? [];

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
        sleep,
        checkedAt,
      ];
}

final class SleepError extends SleepState {
  final Object error;

  const SleepError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
