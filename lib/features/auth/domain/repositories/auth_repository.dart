import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/ui/extensions/auth_type_extension.dart';

abstract class AuthRepository {
  Future<bool> checkSignInStatus();
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  });
  Future<void> resetPassword({
    required String email,
  });
  Future<void> signOut();
}
