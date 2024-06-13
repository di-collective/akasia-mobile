import 'dart:io';

import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/remote/account_remote_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  final NetworkInfo networkInfo;
  final AccountRemoteDataSource accountRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  const AccountRepositoryImpl({
    required this.networkInfo,
    required this.accountRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<ProfileEntity> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: 'access-token-not-found',
          );
        }

        return accountRemoteDataSource.getProfile(
          accessToken: accessToken,
        );
      } on AuthException catch (error) {
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
  Future<void> changeProfilePicture({
    required File image,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: 'access-token-not-found',
          );
        }

        await accountRemoteDataSource.changeProfilePicture(
          accessToken: accessToken,
          image: image,
        );
      } on AuthException catch (error) {
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
  Future<void> updateProfile({
    required ProfileEntity profile,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: 'access-token-not-found',
          );
        }

        await accountRemoteDataSource.updateProfile(
          accessToken: accessToken,
          profile: profile,
        );
      } on AuthException catch (error) {
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
