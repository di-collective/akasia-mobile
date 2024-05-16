import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/ui/extensions/auth_type_extension.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  const AuthRepositoryImpl({
    required this.networkInfo,
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? eKtp,
    String? name,
    String? email,
    required String phoneCode,
    required String phoneNumber,
    String? password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.signUp(
          authType: authType,
          eKtp: eKtp,
          name: name,
          email: email,
          phoneCode: phoneCode,
          phoneNumber: phoneNumber,
          password: password,
        );
      } on FirebaseAuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.signIn(
          authType: authType,
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  String? getAccessToken() {
    try {
      return authLocalDataSource.getAccessToken();
    } catch (error) {
      throw AuthException(
        code: error,
      );
    }
  }

  @override
  Future<bool> saveAccessToken({
    required String accessToken,
  }) async {
    try {
      return await authLocalDataSource.saveAccessToken(
        accessToken: accessToken,
      );
    } catch (error) {
      throw AuthException(
        code: error,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.resetPassword(
          email: email,
        );
      } on FirebaseAuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.confirmPasswordReset(
          code: code,
          newPassword: newPassword,
        );
      } on FirebaseAuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }

  @override
  Future<void> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.signOut();
      } on FirebaseAuthException catch (error) {
        throw AuthException(
          code: error.code,
          message: error.message,
        );
      } catch (error) {
        throw AppHttpException(
          code: error,
        );
      }
    } else {
      throw const AppNetworkException();
    }
  }
}
