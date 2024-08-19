import 'dart:io';

import '../entities/profile_entity.dart';

abstract class AccountRepository {
  Future<ProfileEntity> getProfile();
  Future<String?> changeProfilePicture({
    required File image,
    required String? userId,
  });
  Future<ProfileEntity> updateProfile({
    required ProfileEntity profile,
  });
}
