import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/ui/extensions/auth_type_extension.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl({
    required this.networkInfo,
    required this.authRemoteDataSource,
  });

  @override
  Future<bool> checkSignInStatus() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authRemoteDataSource.checkSignInStatus();

        return result;
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
  Future<UserCredential?> signUp({
    required AuthType authType,
    String? name,
    String? email,
    String? password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.signUp(
          authType: authType,
          name: name,
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
