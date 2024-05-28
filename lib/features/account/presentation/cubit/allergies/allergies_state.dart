part of 'allergies_cubit.dart';

sealed class AllergiesState extends Equatable {
  const AllergiesState();

  @override
  List<Object?> get props => [];
}

final class AllergiesInitial extends AllergiesState {}

final class AllergiesLoading extends AllergiesState {}

final class AllergiesLoaded extends AllergiesState {
  final List<AllergyModel> allergies;

  const AllergiesLoaded({
    required this.allergies,
  });

  @override
  List<Object?> get props => [allergies];
}

final class AllergiesError extends AllergiesState {
  final Object error;

  const AllergiesError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
