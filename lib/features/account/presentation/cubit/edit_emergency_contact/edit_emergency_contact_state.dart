part of 'edit_emergency_contact_cubit.dart';

sealed class EditEmergencyContactState extends Equatable {
  const EditEmergencyContactState();

  @override
  List<Object> get props => [];
}

final class EditEmergencyContactInitial extends EditEmergencyContactState {}

final class EditEmergencyContactLoading extends EditEmergencyContactState {}

final class EditEmergencyContactLoaded extends EditEmergencyContactState {}

final class EditEmergencyContactError extends EditEmergencyContactState {
  final Object error;

  const EditEmergencyContactError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
