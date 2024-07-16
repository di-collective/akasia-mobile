part of 'daily_steps_cubit.dart';

sealed class DailyStepsState extends Equatable {
  const DailyStepsState();

  @override
  List<Object?> get props => [];
}

final class DailyStepsInitial extends DailyStepsState {}

final class DailyStepsLoading extends DailyStepsState {}

final class DailyStepsLoaded extends DailyStepsState {}

final class DailyStepsError extends DailyStepsState {}
