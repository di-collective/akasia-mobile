import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../domain/repositories/allergy_repository.dart';
import '../datasources/remote/allergy_remote_datasource.dart';
import '../models/allergy_model.dart';

class AllergyRepositoryImpl implements AllergyRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;
  final AllergyRemoteDataSource allergyRemoteDataSource;

  const AllergyRepositoryImpl({
    required this.networkInfo,
    required this.authLocalDataSource,
    required this.allergyRemoteDataSource,
  });

  @override
  Future<List<AllergyModel>> getAllergies() async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: 'access-token-not-found',
          );
        }

        return await allergyRemoteDataSource.getAllergies(
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
}
