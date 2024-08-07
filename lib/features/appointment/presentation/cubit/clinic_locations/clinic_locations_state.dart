part of 'clinic_locations_cubit.dart';

sealed class ClinicLocationsState extends Equatable {
  const ClinicLocationsState();

  @override
  List<Object?> get props => [];
}

final class ClinicLocationsInitial extends ClinicLocationsState {}

final class ClinicLocationsLoading extends ClinicLocationsState {}

final class ClinicLocationsLoaded extends ClinicLocationsState {
  final List<ClinicLocationEntity> clinicLocations;
  final int? page;
  final bool? hasReachedMax;

  const ClinicLocationsLoaded({
    required this.clinicLocations,
    this.page,
    this.hasReachedMax,
  });

  ClinicLocationsLoaded copyWith({
    List<ClinicLocationEntity>? clinicLocations,
    int? page,
    bool? hasReachedMax,
  }) {
    return ClinicLocationsLoaded(
      clinicLocations: clinicLocations ?? this.clinicLocations,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        clinicLocations,
        page,
        hasReachedMax,
      ];
}

final class ClinicLocationsError extends ClinicLocationsState {
  final Object error;

  const ClinicLocationsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
