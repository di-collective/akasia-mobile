part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  final AuthType authType;

  const SignInState({
    required this.authType,
  });

  @override
  List<Object?> get props => [
        authType,
      ];
}

class SignInInitial extends SignInState {
  const SignInInitial({
    required super.authType,
  });

  @override
  List<Object?> get props => [
        authType,
      ];
}

class SignInLoading extends SignInState {
  const SignInLoading({
    required super.authType,
  });

  @override
  List<Object?> get props => [
        authType,
      ];
}

class SignInLoaded extends SignInState {
  final UserCredential? userCredential;

  const SignInLoaded({
    required super.authType,
    required this.userCredential,
  });

  @override
  List<Object?> get props => [
        authType,
        userCredential,
      ];
}

class SignInError extends SignInState {
  final Object error;

  const SignInError({
    required this.error,
    required super.authType,
  });

  @override
  List<Object?> get props => [
        error,
        authType,
      ];
}
