import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SaveAccessTokenUseCase extends UseCase<bool, SaveAccessTokenParams> {
  final AuthRepository authRepository;

  SaveAccessTokenUseCase({
    required this.authRepository,
  });

  @override
  Future<bool> call(SaveAccessTokenParams params) async {
    return authRepository.saveAccessToken(
      accessToken: params.accessToken,
    );
  }
}

class SaveAccessTokenParams {
  final String accessToken;

  SaveAccessTokenParams({
    required this.accessToken,
  });
}
