import '../../../../core/usecases/usecase.dart';
import '../../data/models/profile_model.dart';
import '../repositories/account_repository.dart';

class GetProfileUseCase extends UseCase<ProfileModel, NoParams> {
  final AccountRepository accountRepository;

  GetProfileUseCase({
    required this.accountRepository,
  });

  @override
  Future<ProfileModel> call(NoParams params) async {
    return accountRepository.getProfile();
  }
}
