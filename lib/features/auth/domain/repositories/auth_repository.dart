import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/ui/extensions/auth_type_extension.dart';

abstract class AuthRepository {
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? eKtp,
    String? name,
    String? email,
    required String phoneCode,
    required String phoneNumber,
    String? password,
  });
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  });
  String? getAccessToken();
  Future<bool> saveAccessToken({
    required String accessToken,
  });
  Future<void> resetPassword({
    required String email,
  });
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  });
  Future<void> signOut();
}
