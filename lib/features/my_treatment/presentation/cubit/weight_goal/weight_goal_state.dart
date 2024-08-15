part of 'weight_goal_cubit.dart';

sealed class WeightGoalState extends Equatable {
  const WeightGoalState();

  @override
  List<Object?> get props => [];
}

final class WeightGoalInitial extends WeightGoalState {}

final class WeightGoalLoading extends WeightGoalState {}

final class WeightGoalLoaded extends WeightGoalState {
  final WeightGoalEntity? weightGoal;

  const WeightGoalLoaded({
    required this.weightGoal,
  });

  @override
  List<Object?> get props => [weightGoal];
}

final class WeightGoalError extends WeightGoalState {
  final Object error;

  const WeightGoalError({
    required this.error,
  });
}
