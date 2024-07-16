part of 'daily_workouts_cubit.dart';

sealed class DailyWorkoutsState extends Equatable {
  const DailyWorkoutsState();

  @override
  List<Object?> get props => [];
}

final class DailyWorkoutsInitial extends DailyWorkoutsState {}

final class DailyWorkoutsLoading extends DailyWorkoutsState {}

final class DailyWorkoutsLoaded extends DailyWorkoutsState {
  final List<double> data;

  const DailyWorkoutsLoaded({
    required this.data,
  });

  DailyWorkoutsLoaded copyWith({
    List<double>? data,
  }) {
    return DailyWorkoutsLoaded(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}

final class DailyWorkoutsError extends DailyWorkoutsState {
  final Object error;

  const DailyWorkoutsError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
