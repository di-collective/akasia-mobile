part of 'create_appointment_cubit.dart';

sealed class CreateAppointmentState extends Equatable {
  const CreateAppointmentState();

  @override
  List<Object> get props => [];
}

final class CreateAppointmentInitial extends CreateAppointmentState {}

final class CreateAppointmentLoading extends CreateAppointmentState {}

final class CreateAppointmentLoaded extends CreateAppointmentState {}

final class CreateAppointmentError extends CreateAppointmentState {
  final Object error;

  const CreateAppointmentError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
