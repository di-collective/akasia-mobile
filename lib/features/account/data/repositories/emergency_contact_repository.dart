import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../domain/repositories/emergency_contact_repository.dart';
import '../datasources/remote/emergency_contact_remote_datasource.dart';
import '../models/emergency_contact_model.dart';

class EmergencyContactRepositoryImpl implements EmergencyContactRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;
  final EmergencyContactRemoteDataSource emergencyContactRemoteDataSource;

  const EmergencyContactRepositoryImpl({
    required this.networkInfo,
    required this.authLocalDataSource,
    required this.emergencyContactRemoteDataSource,
  });

  @override
  Future<EmergencyContactModel> getEmergencyContact() async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: 'access-token-not-found',
          );
        }

        return await emergencyContactRemoteDataSource.getEmergencyContact(
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
  Future<void> editEmergencyContact({
    required EmergencyContactModel emergencyContact,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: 'access-token-not-found',
          );
        }

        await emergencyContactRemoteDataSource.editEmergencyContact(
          accessToken: accessToken,
          emergencyContact: emergencyContact,
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
