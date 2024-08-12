part of 'appointments_cubit.dart';

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

final class AppointmentsInitial extends AppointmentsState {}

final class AppointmentsLoading extends AppointmentsState {}

final class AppointmentsLoaded extends AppointmentsState {
  final List schedules;

  const AppointmentsLoaded({
    required this.schedules,
  });

  @override
  List<Object> get props => [schedules];
}

final class AppointmentsError extends AppointmentsState {
  final Object error;

  const AppointmentsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
