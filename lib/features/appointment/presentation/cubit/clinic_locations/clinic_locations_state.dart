part of 'clinic_locations_cubit.dart';

sealed class ClinicLocationsState extends Equatable {
  const ClinicLocationsState();

  @override
  List<Object> get props => [];
}

final class ClinicLocationsInitial extends ClinicLocationsState {}

final class ClinicLocationsLoading extends ClinicLocationsState {}

final class ClinicLocationsLoaded extends ClinicLocationsState {
  final List<ClinicLocationEntity> clinicLocations;

  const ClinicLocationsLoaded({
    required this.clinicLocations,
  });

  @override
  List<Object> get props => [clinicLocations];
}

final class ClinicLocationsError extends ClinicLocationsState {
  final Object error;

  const ClinicLocationsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
