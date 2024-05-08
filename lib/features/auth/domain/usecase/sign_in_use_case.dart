import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/ui/extensions/auth_type_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase extends UseCase<UserCredential?, SignInParams> {
  final AuthRepository authRepository;

  SignInUseCase({
    required this.authRepository,
  });

  @override
  Future<UserCredential?> call(SignInParams params) async {
    return await authRepository.signIn(
      authType: params.authType,
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams {
  final AuthType authType;
  final String? email;
  final String? password;

  SignInParams({
    required this.authType,
    this.email,
    this.password,
  });
}
