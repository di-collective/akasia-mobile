part of 'workout_cubit.dart';

sealed class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

final class WorkoutInitial extends WorkoutState {}

final class WorkoutLoading extends WorkoutState {}

final class WorkoutLoaded extends WorkoutState {
  final ActivityEntity<List<WorkoutActivityEntity>>? workout;

  const WorkoutLoaded({
    required this.workout,
  });

  WorkoutLoaded copyWith({
    ActivityEntity<List<WorkoutActivityEntity>>? workout,
  }) {
    return WorkoutLoaded(
      workout: workout ?? this.workout,
    );
  }

  List<WorkoutActivityEntity> getLastSevenData() {
    final List<WorkoutActivityEntity> result = [];

    final allData = workout?.data ?? [];
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

  Map<DateTime, List<WorkoutActivityEntity>> getCurrentWeekData() {
    final Map<DateTime, List<WorkoutActivityEntity>> result = {};
    final allData = workout?.data ?? [];

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
  List<Object?> get props => [workout];
}

final class WorkoutError extends WorkoutState {
  final Object error;

  const WorkoutError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
