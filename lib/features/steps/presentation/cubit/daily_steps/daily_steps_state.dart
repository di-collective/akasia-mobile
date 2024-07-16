part of 'daily_steps_cubit.dart';

sealed class DailyStepsState extends Equatable {
  const DailyStepsState();

  @override
  List<Object?> get props => [];
}

final class DailyStepsInitial extends DailyStepsState {}

final class DailyStepsLoading extends DailyStepsState {}

final class DailyStepsLoaded extends DailyStepsState {
  final List<double> data;

  const DailyStepsLoaded({
    required this.data,
  });

  DailyStepsLoaded copyWith({
    List<double>? data,
  }) {
    return DailyStepsLoaded(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}

final class DailyStepsError extends DailyStepsState {
  final Object error;

  const DailyStepsError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
