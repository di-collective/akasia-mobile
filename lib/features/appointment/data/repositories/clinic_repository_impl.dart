import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/ui/extensions/app_exception_extension.dart';
import '../../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/entities/clinic_location_entity.dart';
import '../../domain/repositories/clinic_repository.dart';
import '../datasources/clinic_remote_datasource.dart';

class ClinicRepositoryImpl implements ClinicRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;
  final ClinicRemoteDataSource clinicRemoteDataSource;

  ClinicRepositoryImpl({
    required this.networkInfo,
    required this.authLocalDataSource,
    required this.clinicRemoteDataSource,
  });

  @override
  Future<List<ClinicEntity>> getClinics() async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return clinicRemoteDataSource.getClinics(
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
  Future<List<ClinicLocationEntity>> getClinicLocations({
    required String? clinicId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return await clinicRemoteDataSource.getClinicLocations(
          accessToken: accessToken,
          clinicId: clinicId,
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
