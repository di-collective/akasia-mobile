import '../../../../core/config/env_config.dart';
import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../core/utils/logger.dart';
import '../models/calendar_appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<CalendarAppointmentModel> getEvents({
    required String? accessToken,
    required String? locationId,
    required DateTime? startTime,
    required DateTime? endTime,
    int? page,
    int? limit,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final AppHttpClient appHttpClient;

  AppointmentRemoteDataSourceImpl({
    required this.appHttpClient,
  });

  @override
  Future<CalendarAppointmentModel> getEvents({
    required String? accessToken,
    required String? locationId,
    required DateTime? startTime,
    required DateTime? endTime,
    int? page,
    int? limit,
  }) async {
    try {
      Logger.info('getEvents accessToken: $accessToken');

      final response = await appHttpClient.get(
        url: "${EnvConfig.akasiaCalendarApiUrl}/events",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'page': page,
          'limit': limit,
          'location_id': locationId,
          'start_time': startTime?.toDateApi,
          'end_time': endTime?.toDateApi,
          'type': EventType.holiday.name,
        },
      );
      Logger.success('getEvents response: $response');

      return CalendarAppointmentModel.fromJson(
        response.data['data'],
      );
    } catch (error) {
      Logger.error('getEvents error: $error');

      rethrow;
    }
  }
}
