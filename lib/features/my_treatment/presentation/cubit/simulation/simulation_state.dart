part of 'simulation_cubit.dart';

sealed class SimulationState extends Equatable {
  const SimulationState();

  @override
  List<Object> get props => [];
}

final class SimulationInitial extends SimulationState {}

final class SimulationLoading extends SimulationState {}

final class SimulationLoaded extends SimulationState {
  final WeightGoalSimulationEntity simulation;

  const SimulationLoaded({
    required this.simulation,
  });

  @override
  List<Object> get props => [simulation];
}

final class SimulationError extends SimulationState {
  final Object error;

  const SimulationError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
