part of 'nutrition_cubit.dart';

sealed class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object?> get props => [];
}

final class NutritionInitial extends NutritionState {}

final class NutritionLoading extends NutritionState {}

final class NutritionLoaded extends NutritionState {
  final List<double> nutritions;

  const NutritionLoaded({
    required this.nutritions,
  });

  NutritionLoaded copyWith({
    List<double>? nutritions,
  }) {
    return NutritionLoaded(
      nutritions: nutritions ?? this.nutritions,
    );
  }

  Map<DateTime, List<NutritionActivityEntity>> getCurrentWeekData() {
    final Map<DateTime, List<NutritionActivityEntity>> result = {};
    // final allData = nutritions?.data ?? [];

    final currentDate = DateTime.now();
    final firstDate = currentDate.firstDayOfTheWeek;
    // get date from first day of the week
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      final date = firstDate.addDays(i);

      // final data = allData.where((element) {
      //   return element.fromDate?.isSameDay(other: date) ?? false;
      // });

      result.addAll({
        date: [],
      });
    }

    return result;
  }

  @override
  List<Object?> get props => [nutritions];
}

final class NutritionError extends NutritionState {
  final Object error;

  const NutritionError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
