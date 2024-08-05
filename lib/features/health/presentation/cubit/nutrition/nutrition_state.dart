part of 'nutrition_cubit.dart';

sealed class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object?> get props => [];
}

final class NutritionInitial extends NutritionState {}

final class NutritionLoading extends NutritionState {}

final class NutritionLoaded extends NutritionState {
  final ActivityEntity<List<NutritionActivityEntity>>? nutritions;
  final DateTime? checkedAt;

  const NutritionLoaded({
    required this.nutritions,
    required this.checkedAt,
  });

  NutritionLoaded copyWith({
    ActivityEntity<List<NutritionActivityEntity>>? nutritions,
    DateTime? checkedAt,
  }) {
    return NutritionLoaded(
      nutritions: nutritions ?? this.nutritions,
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }

  List<NutritionActivityEntity>? getLastSevenData() {
    final List<NutritionActivityEntity> result = [];

    final allData = nutritions?.data ?? [];
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

  Map<DateTime, List<NutritionActivityEntity>> getCurrentWeekData() {
    final Map<DateTime, List<NutritionActivityEntity>> result = {};
    final allData = nutritions?.data ?? [];

    final currentDate = DateTime.now();
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
        nutritions,
        checkedAt,
      ];
}

final class NutritionError extends NutritionState {
  final Object error;

  const NutritionError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
