import 'package:injectable/injectable.dart';
import '../model/user.dart';
import '../repository/auth_repository.dart';
import '../../../../core/common/result.dart';

@LazySingleton()
class LoginUseCase {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<User>> execute(String email, String password) {
    return _authRepository.login(email, password);
  }
}
