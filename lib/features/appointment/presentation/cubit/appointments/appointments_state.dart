part of 'appointments_cubit.dart';

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

final class AppointmentsInitial extends AppointmentsState {}

final class AppointmentsLoading extends AppointmentsState {}

final class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentEntity> appointments;

  const AppointmentsLoaded({
    required this.appointments,
  });

  AppointmentsLoaded copyWith({
    List<AppointmentEntity>? appointments,
  }) {
    return AppointmentsLoaded(
      appointments: appointments ?? this.appointments,
    );
  }

  @override
  List<Object> get props => [appointments];
}

final class AppointmentsError extends AppointmentsState {
  final Object error;

  const AppointmentsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
