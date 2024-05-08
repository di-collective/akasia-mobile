import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckSignInStatusUseCase extends UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  CheckSignInStatusUseCase({
    required this.authRepository,
  });

  @override
  Future<bool> call(NoParams params) async {
    return await authRepository.checkSignInStatus();
  }
}
