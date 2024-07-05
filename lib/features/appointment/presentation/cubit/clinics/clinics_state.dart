part of 'clinics_cubit.dart';

sealed class ClinicsState extends Equatable {
  const ClinicsState();

  @override
  List<Object> get props => [];
}

final class ClinicsInitial extends ClinicsState {}

final class ClinicsLoading extends ClinicsState {}

final class ClinicsLoaded extends ClinicsState {
  final List<ClinicEntity> clinics;

  const ClinicsLoaded({
    required this.clinics,
  });

  @override
  List<Object> get props => [clinics];
}

final class ClinicsError extends ClinicsState {
  final Object error;

  const ClinicsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
