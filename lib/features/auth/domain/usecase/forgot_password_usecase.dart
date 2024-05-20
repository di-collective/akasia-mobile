import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository authRepository;

  ForgotPasswordUseCase({
    required this.authRepository,
  });

  @override
  Future<void> call(ForgotPasswordParams params) async {
    return await authRepository.forgotPassword(
      email: params.email,
    );
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({
    required this.email,
  });
}
