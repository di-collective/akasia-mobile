part of 'emergency_contact_cubit.dart';

sealed class EmergencyContactState extends Equatable {
  const EmergencyContactState();

  @override
  List<Object?> get props => [];
}

final class EmergencyContactInitial extends EmergencyContactState {}

final class EmergencyContactLoading extends EmergencyContactState {}

final class EmergencyContactLoaded extends EmergencyContactState {
  final EmergencyContactModel emergencyContact;

  const EmergencyContactLoaded({
    required this.emergencyContact,
  });

  @override
  List<Object?> get props => [emergencyContact];
}

final class EmergencyContactError extends EmergencyContactState {
  final Object error;

  const EmergencyContactError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
