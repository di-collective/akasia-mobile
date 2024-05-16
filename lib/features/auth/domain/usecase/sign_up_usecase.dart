import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/ui/extensions/auth_type_extension.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase extends UseCase<void, SignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase({
    required this.authRepository,
  });

  @override
  Future<UserCredential?> call(SignUpParams params) async {
    return await authRepository.signUp(
      authType: params.authType,
      eKtp: params.eKtp,
      name: params.name,
      email: params.email,
      phoneCode: params.phoneCode,
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
  }
}

class SignUpParams {
  final AuthType authType;
  final String? eKtp;
  final String? name;
  final String? email;
  final String phoneCode;
  final String phoneNumber;
  final String? password;

  SignUpParams({
    required this.authType,
    required this.eKtp,
    required this.name,
    required this.email,
    required this.phoneCode,
    required this.phoneNumber,
    required this.password,
  });
}
