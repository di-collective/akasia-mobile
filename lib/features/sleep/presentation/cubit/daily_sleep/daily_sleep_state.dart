part of 'daily_sleep_cubit.dart';

sealed class DailySleepState extends Equatable {
  const DailySleepState();

  @override
  List<Object?> get props => [];
}

final class DailySleepInitial extends DailySleepState {}

final class DailySleepLoading extends DailySleepState {}

final class DailySleepLoaded extends DailySleepState {
  final List<double> data;

  const DailySleepLoaded({
    required this.data,
  });

  DailySleepLoaded copyWith({
    List<double>? data,
  }) {
    return DailySleepLoaded(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}

final class DailySleepError extends DailySleepState {
  final Object error;

  const DailySleepError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
