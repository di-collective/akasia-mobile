part of 'daily_nutritions_cubit.dart';

sealed class DailyNutritionsState extends Equatable {
  const DailyNutritionsState();

  @override
  List<Object?> get props => [];
}

final class DailyNutritionsInitial extends DailyNutritionsState {}

final class DailyNutritionsLoading extends DailyNutritionsState {}

final class DailyNutritionsLoaded extends DailyNutritionsState {
  final List<double> data;

  const DailyNutritionsLoaded({
    required this.data,
  });

  DailyNutritionsLoaded copyWith({
    List<double>? data,
  }) {
    return DailyNutritionsLoaded(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}

final class DailyNutritionsError extends DailyNutritionsState {
  final Object error;

  const DailyNutritionsError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
