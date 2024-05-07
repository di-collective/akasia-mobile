import 'package:injectable/injectable.dart';

import '../../../domain/model/user.dart';

@LazySingleton()
class AuthLocalDataSource {
  Future<User> getUser() async {
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        return const User(token: 'token', refreshToken: 'refreshToken');
      },
    );
  }
}
