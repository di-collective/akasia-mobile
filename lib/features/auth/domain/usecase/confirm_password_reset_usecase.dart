import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ConfirmPasswordResetUseCase
    extends UseCase<void, ConfirmPasswordResetParams> {
  final AuthRepository authRepository;

  ConfirmPasswordResetUseCase({
    required this.authRepository,
  });

  @override
  Future<void> call(ConfirmPasswordResetParams params) async {
    return await authRepository.confirmPasswordReset(
      code: params.code,
      newPassword: params.newPassword,
    );
  }
}

class ConfirmPasswordResetParams {
  final String code;
  final String newPassword;

  ConfirmPasswordResetParams({
    required this.code,
    required this.newPassword,
  });
}
