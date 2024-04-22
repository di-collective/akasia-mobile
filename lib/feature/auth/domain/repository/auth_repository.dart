import '../../../../feature/auth/domain/model/user.dart';
import '../../../../core/common/result.dart';

abstract interface class AuthRepository {
  Future<Result<User>> login(String email, String password);

  Future<Result<User>> updateToken();
}
