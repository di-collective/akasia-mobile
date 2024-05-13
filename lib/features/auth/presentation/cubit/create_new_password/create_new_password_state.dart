part of 'create_new_password_cubit.dart';

sealed class CreateNewPasswordState extends Equatable {
  const CreateNewPasswordState();

  @override
  List<Object?> get props => [];
}

class CreateNewPasswordInitial extends CreateNewPasswordState {}

class CreateNewPasswordLoading extends CreateNewPasswordState {}

class CreateNewPasswordLoaded extends CreateNewPasswordState {}

class CreateNewPasswordError extends CreateNewPasswordState {
  final Object error;

  const CreateNewPasswordError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
