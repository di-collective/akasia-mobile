part of 'get_allergies_cubit.dart';

sealed class GetAllergiesState extends Equatable {
  const GetAllergiesState();

  @override
  List<Object?> get props => [];
}

final class GetAllergiesInitial extends GetAllergiesState {}

final class GetAllergiesLoading extends GetAllergiesState {}

final class GetAllergiesLoaded extends GetAllergiesState {
  final List<AllergyModel> allergies;

  const GetAllergiesLoaded({
    required this.allergies,
  });

  @override
  List<Object?> get props => [allergies];
}

final class GetAllergiesError extends GetAllergiesState {
  final Object error;

  const GetAllergiesError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
