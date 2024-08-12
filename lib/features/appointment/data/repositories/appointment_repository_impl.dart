import '../../../../core/common/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/ui/extensions/app_exception_extension.dart';
import '../../../auth/data/datasources/local/auth_local_datasource.dart';
import '../../domain/entities/calendar_appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_datasource.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final NetworkInfo networkInfo;
  final AuthLocalDataSource authLocalDataSource;
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  AppointmentRepositoryImpl({
    required this.networkInfo,
    required this.authLocalDataSource,
    required this.appointmentRemoteDataSource,
  });

  @override
  Future<CalendarAppointmentEntity> getEvents({
    required String? locationId,
    required DateTime? startTime,
    required DateTime? endTime,
    int? page,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final accessToken = authLocalDataSource.getAccessToken();
        if (accessToken == null) {
          throw const AuthException(
            code: AppExceptionType.accessTokenNotFound,
          );
        }

        return appointmentRemoteDataSource.getEvents(
          accessToken: accessToken,
          locationId: locationId,
          startTime: startTime,
          endTime: endTime,
          page: page,
          limit: limit,
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
