import 'dart:io';

import '../../data/models/profile_model.dart';

abstract class AccountRepository {
  Future<ProfileModel> getProfile();
  Future<void> changeProfilePicture({
    required File image,
  });
}
