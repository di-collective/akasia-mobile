import 'dart:io';

import '../entities/profile_entity.dart';

abstract class AccountRepository {
  Future<ProfileEntity> getProfile();
  Future<void> changeProfilePicture({
    required File image,
  });
  Future<void> updateProfile({
    required ProfileEntity profile,
  });
}
