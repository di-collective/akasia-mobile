part of 'weight_history_cubit.dart';

sealed class WeightHistoryState extends Equatable {
  const WeightHistoryState();

  @override
  List<Object> get props => [];
}

final class WeightHistoryInitial extends WeightHistoryState {}

final class WeightHistoryLoading extends WeightHistoryState {}

final class WeightHistoryLoaded extends WeightHistoryState {
  final List<WeightHistoryEntity> weights;

  const WeightHistoryLoaded({
    required this.weights,
  });

  WeightHistoryLoaded copyWith({
    List<WeightHistoryEntity>? weights,
  }) {
    return WeightHistoryLoaded(
      weights: weights ?? this.weights,
    );
  }

  WeightHistoryEntity? get latestWeight {
    if (weights.isEmpty) {
      return null;
    }

    return weights.first;
  }

  @override
  List<Object> get props => [weights];
}

final class WeightHistoryError extends WeightHistoryState {
  final Object error;

  const WeightHistoryError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
