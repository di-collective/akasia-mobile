import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase extends UseCase<void, SignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase({
    required this.authRepository,
  });

  @override
  Future<void> call(SignUpParams params) async {
    return await authRepository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
