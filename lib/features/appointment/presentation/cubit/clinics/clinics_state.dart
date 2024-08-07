part of 'clinics_cubit.dart';

sealed class ClinicsState extends Equatable {
  const ClinicsState();

  @override
  List<Object?> get props => [];
}

final class ClinicsInitial extends ClinicsState {}

final class ClinicsLoading extends ClinicsState {}

final class ClinicsLoaded extends ClinicsState {
  final List<ClinicEntity> clinics;
  final int? page;
  final bool? hasReachedMax;

  const ClinicsLoaded({
    required this.clinics,
    this.page,
    this.hasReachedMax,
  });

  ClinicsLoaded copyWith({
    List<ClinicEntity>? clinics,
    int? page,
    bool? hasReachedMax,
  }) {
    return ClinicsLoaded(
      clinics: clinics ?? this.clinics,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        clinics,
        page,
        hasReachedMax,
      ];
}

final class ClinicsError extends ClinicsState {
  final Object error;

  const ClinicsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
