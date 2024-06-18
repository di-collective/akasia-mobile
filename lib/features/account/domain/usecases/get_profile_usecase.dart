import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/account_repository.dart';

class GetProfileUseCase extends UseCase<ProfileEntity, NoParams> {
  final AccountRepository accountRepository;

  GetProfileUseCase({
    required this.accountRepository,
  });

  @override
  Future<ProfileEntity> call(NoParams params) async {
    return await accountRepository.getProfile();
  }
}
