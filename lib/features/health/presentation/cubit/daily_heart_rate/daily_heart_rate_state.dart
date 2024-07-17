part of 'daily_heart_rate_cubit.dart';

sealed class DailyHeartRateState extends Equatable {
  const DailyHeartRateState();

  @override
  List<Object?> get props => [];
}

final class DailyHeartRateInitial extends DailyHeartRateState {}

final class DailyHeartRateLoading extends DailyHeartRateState {}

final class DailyHeartRateLoaded extends DailyHeartRateState {
  final List<double> data;

  const DailyHeartRateLoaded({
    required this.data,
  });

  DailyHeartRateLoaded copyWith({
    List<double>? data,
  }) {
    return DailyHeartRateLoaded(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [data];
}

final class DailyHeartRateError extends DailyHeartRateState {
  final Object error;

  const DailyHeartRateError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
