import 'dart:io';

import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class ChangeProfilePictureUseCase
    extends UseCase<String?, ChangeProfilePictureParams> {
  final AccountRepository accountRepository;

  ChangeProfilePictureUseCase({
    required this.accountRepository,
  });

  @override
  Future<String?> call(ChangeProfilePictureParams params) async {
    return await accountRepository.changeProfilePicture(
      image: params.image,
      userId: params.userId,
    );
  }
}

class ChangeProfilePictureParams {
  final File image;
  final String? userId;

  ChangeProfilePictureParams({
    required this.image,
    required this.userId,
  });
}
