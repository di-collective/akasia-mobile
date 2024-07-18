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

        result.add(StepsActivityEntity(
          date: DateTime.now().addDays(lastOffset),
          count: 0,
        ));
      }
    }

    return result;
  }

  StepsActivityEntity? get todaySteps {
    final allData = steps?.data ?? [];
    if (allData.isNotEmpty) {
      return allData.last;
    }

    return null;
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
