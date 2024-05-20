import 'dart:io';

abstract class AccountRepository {
  Future<void> changeProfilePicture({
    required File image,
  });
}
