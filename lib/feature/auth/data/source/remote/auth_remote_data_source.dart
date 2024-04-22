import '../../../../../core/common/exception.dart';
import '../../../../../core/network/http/app_http_client.dart';
import 'package:injectable/injectable.dart';

import '../../model/user_model.dart';

@LazySingleton()
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._networkClient);

  final AppHttpClient _networkClient;

  Future<UserModel> login(String email, String password) async {
    try {
      final data = await _networkClient.post(
        url: '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return UserModel.fromJson(data);
    } on AppException {
      rethrow;
    }
  }

  Future<UserModel> updateToken(String refreshToken) async {
    try {
      final data = await _networkClient.post(
        url: '/refreshToken',
        data: {'refresh_token': refreshToken},
      );
      return UserModel.fromJson(data);
    } on AppException {
      rethrow;
    }
  }
}
