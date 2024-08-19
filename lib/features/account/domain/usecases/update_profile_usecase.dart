import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/account_repository.dart';

class UpdateProfileUseCase extends UseCase<ProfileEntity, UpdateProfileParams> {
  final AccountRepository accountRepository;

  UpdateProfileUseCase({
    required this.accountRepository,
  });

  @override
  Future<ProfileEntity> call(UpdateProfileParams params) async {
    return await accountRepository.updateProfile(
      profile: params.profile,
    );
  }
}

class UpdateProfileParams {
  final ProfileEntity profile;

  UpdateProfileParams({
    required this.profile,
  });
}
