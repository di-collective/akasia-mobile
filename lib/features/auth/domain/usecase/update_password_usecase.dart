import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase extends UseCase<void, UpdatePasswordUseCaseParams> {
  final AuthRepository authRepository;

  UpdatePasswordUseCase({
    required this.authRepository,
  });

  @override
  Future<void> call(UpdatePasswordUseCaseParams params) async {
    return await authRepository.updatePassword(
      userId: params.userId,
      resetToken: params.resetToken,
      newPassword: params.newPassword,
    );
  }
}

class UpdatePasswordUseCaseParams {
  final String userId;
  final String resetToken;
  final String newPassword;

  UpdatePasswordUseCaseParams({
    required this.userId,
    required this.resetToken,
    required this.newPassword,
  });
}
