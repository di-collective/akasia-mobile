part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordLoaded extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final Object error;

  const ForgotPasswordError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
