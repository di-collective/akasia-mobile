import 'dart:io';

import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class ChangeProfilePictureUseCase
    extends UseCase<void, ChangeProfilePictureParams> {
  final AccountRepository accountRepository;

  ChangeProfilePictureUseCase({
    required this.accountRepository,
  });

  @override
  Future<void> call(ChangeProfilePictureParams params) async {
    return await accountRepository.changeProfilePicture(
      image: params.image,
    );
  }
}

class ChangeProfilePictureParams {
  final File image;

  ChangeProfilePictureParams({
    required this.image,
  });
}
