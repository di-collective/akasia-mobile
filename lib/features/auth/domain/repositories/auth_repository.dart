import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/ui/extensions/auth_type_extension.dart';

abstract class AuthRepository {
  Future<bool> checkSignInStatus();
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? email,
    String? password,
  });
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
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
