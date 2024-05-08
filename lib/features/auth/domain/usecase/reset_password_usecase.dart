import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPasswordUseCase({
    required this.authRepository,
  });

  @override
  Future<void> call(ResetPasswordParams params) async {
    return await authRepository.resetPassword(
      email: params.email,
    );
  }
}

class ResetPasswordParams {
  final String email;

  ResetPasswordParams({
    required this.email,
  });
}
