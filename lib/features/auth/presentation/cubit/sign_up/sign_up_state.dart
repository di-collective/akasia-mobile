part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  final AuthType authType;

  const SignUpState({
    required this.authType,
  });

  @override
  List<Object?> get props => [
        authType,
      ];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial({
    required super.authType,
  });

  @override
  List<Object?> get props => [
        authType,
      ];
}

class SignUpLoading extends SignUpState {
  const SignUpLoading({
    required super.authType,
  });

  @override
  List<Object?> get props => [
        authType,
      ];
}

class SignUpLoaded extends SignUpState {
  final UserCredential? userCredential;

  const SignUpLoaded({
    required super.authType,
    required this.userCredential,
  });

  @override
  List<Object?> get props => [
        authType,
        userCredential,
      ];
}

class SignUpError extends SignUpState {
  final Object error;

  const SignUpError({
    required this.error,
    required super.authType,
  });

  @override
  List<Object?> get props => [
        error,
        authType,
      ];
}
