import '../../../../core/common/exception.dart';
import '../source/local/auth_local_data_source.dart';
import '../source/remote/auth_remote_data_source.dart';
import '../../domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/result.dart';
import '../../domain/model/user.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authLocalDataSource, this._authRemoteDataSource);

  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final result = await _authRemoteDataSource.login(email, password);
      return Result.success(data: result.toUser());
    } on AppException catch (e) {
      return Result.error(error: e);
    }
  }

  @override
  Future<Result<User>> updateToken() async {
    try {
      final current = await _authLocalDataSource.getUser();
      final result = await _authRemoteDataSource.updateToken(current.refreshToken);
      return Result.success(data: result.toUser());
    } on AppException catch (e) {
      return Result.error(error: e);
    }
  }
}
