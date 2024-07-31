part of 'health_service_cubit.dart';

sealed class HealthServiceState extends Equatable {
  const HealthServiceState();

  @override
  List<Object> get props => [];
}

final class HealthServiceInitial extends HealthServiceState {}

final class HealthServiceLoading extends HealthServiceState {}

final class HealthServiceConnected extends HealthServiceState {}

final class HealthServiceDisconnected extends HealthServiceState {}

final class HealthServiceError extends HealthServiceState {
  final Object error;

  const HealthServiceError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
