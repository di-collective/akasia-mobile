part of 'edit_allergies_cubit.dart';

sealed class EditAllergiesState extends Equatable {
  const EditAllergiesState();

  @override
  List<Object> get props => [];
}

final class EditAllergiesInitial extends EditAllergiesState {}

final class EditAllergiesLoading extends EditAllergiesState {}

final class EditAllergiesLoaded extends EditAllergiesState {}

final class EditAllergiesError extends EditAllergiesState {
  final Object error;

  const EditAllergiesError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
