import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository authRepository;

  SignOutUseCase({
    required this.authRepository,
  });

  @override
  Future<void> call(NoParams params) async {
    return authRepository.signOut();
  }
}
