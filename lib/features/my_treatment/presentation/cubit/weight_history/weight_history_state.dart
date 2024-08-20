part of 'weight_history_cubit.dart';

sealed class WeightHistoryState extends Equatable {
  const WeightHistoryState();

  @override
  List<Object> get props => [];
}

final class WeightHistoryInitial extends WeightHistoryState {}

final class WeightHistoryLoading extends WeightHistoryState {}

final class WeightHistoryLoaded extends WeightHistoryState {
  final List<WeightHistoryEntity> histories;

  const WeightHistoryLoaded({
    required this.histories,
  });

  WeightHistoryLoaded copyWith({
    List<WeightHistoryEntity>? histories,
  }) {
    return WeightHistoryLoaded(
      histories: histories ?? this.histories,
    );
  }

  WeightHistoryEntity? get latestHistory {
    if (histories.isEmpty) {
      return null;
    }

    return histories.first;
  }

  @override
  List<Object> get props => [histories];
}

final class WeightHistoryError extends WeightHistoryState {
  final Object error;

  const WeightHistoryError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
