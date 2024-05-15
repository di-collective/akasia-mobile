import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class GetAccessTokenUseCase extends UseCase<String?, NoParams> {
  final AuthRepository authRepository;

  GetAccessTokenUseCase({
    required this.authRepository,
  });

  @override
  Future<String?> call(NoParams params) async {
    return authRepository.getAccessToken();
  }
}
