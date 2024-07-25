part of 'steps_cubit.dart';

sealed class StepsState extends Equatable {
  const StepsState();

  @override
  List<Object?> get props => [];
}

final class StepsInitial extends StepsState {}

final class StepsLoading extends StepsState {}

final class StepsLoaded extends StepsState {
  final ActivityEntity<List<StepsActivityEntity>>? steps;

  const StepsLoaded({
    required this.steps,
  });

  StepsLoaded copyWith({
    ActivityEntity<List<StepsActivityEntity>>? steps,
  }) {
    return StepsLoaded(
      steps: steps ?? this.steps,
    );
  }

  List<StepsActivityEntity>? getLastOneWeekData() {
    final List<StepsActivityEntity> result = [];

    final allData = steps?.data ?? [];
    if (allData.isNotEmpty) {
      for (int i = 7; i >= 0; i--) {
        final lastOffset = allData.length - i;
        if (lastOffset >= 0) {
          if (allData.length > lastOffset) {
            result.add(allData[lastOffset]);
          }
          continue;
        }

        // add empty data if no data in that date
        result.add(StepsActivityEntity(
          date: DateTime.now().addDays(lastOffset),
          count: 0,
        ));
      }
    }

    return result;
  }

  List<StepsActivityEntity>? getCurrentWeekData() {
    final List<StepsActivityEntity> result = [];
    final allData = steps?.data ?? [];

    final currentDate = DateTime.now();
    final firstDate = currentDate.firstDayOfTheWeek;
    // get date from first day of the week
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final date = firstDate.addDays(i);
      final data = allData.firstWhereOrNull((element) {
        return element.date?.isSameDay(other: date) ?? false;
      });

      if (data != null) {
        result.add(data);
      } else {
        result.add(StepsActivityEntity(
          date: date,
          count: null,
        ));
      }
    }

    return result;
  }

  @override
  List<Object?> get props => [steps];
}

final class StepsError extends StepsState {
  final Object error;

  const StepsError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
