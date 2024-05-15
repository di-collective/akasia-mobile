import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app/config/preference_key.dart';
import '../../../../../app/observers/logger.dart';

abstract class AuthLocalDataSource {
  String? getAccessToken();
  String? getRefreshToken();
  Future<bool> saveAccessToken({
    required String accessToken,
  });
  Future<bool> saveRefreshToken({
    required String refreshToken,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  String? getAccessToken() {
    try {
      Logger.info('getAccessToken');

      final result = sharedPreferences.getString(PreferenceKey.accessToken);
      Logger.success('getAccessToken result $result');

      return result;
    } catch (error) {
      Logger.error('getAccessToken error $error');

      rethrow;
    }
  }

  @override
  Future<bool> saveAccessToken({
    required String accessToken,
  }) async {
    try {
      Logger.info('saveToken accessToken $accessToken');

      final result = await sharedPreferences.setString(
        PreferenceKey.accessToken,
        accessToken,
      );
      Logger.success('saveToken result $result');

      return result;
    } catch (error) {
      Logger.error('saveToken error $error');

      rethrow;
    }
  }

  @override
  String? getRefreshToken() {
    try {
      Logger.info('getRefreshToken');

      final result = sharedPreferences.getString(PreferenceKey.refreshToken);
      Logger.success('getRefreshToken result $result');

      return result;
    } catch (error) {
      Logger.error('getRefreshToken error $error');

      rethrow;
    }
  }

  @override
  Future<bool> saveRefreshToken({
    required String refreshToken,
  }) async {
    try {
      Logger.info('saveRefreshToken refreshToken $refreshToken');

      final result = await sharedPreferences.setString(
        PreferenceKey.refreshToken,
        refreshToken,
      );
      Logger.success('saveRefreshToken result $result');

      return result;
    } catch (error) {
      Logger.error('saveRefreshToken error $error');

      rethrow;
    }
  }
}
