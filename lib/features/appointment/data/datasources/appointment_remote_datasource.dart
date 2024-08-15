import '../../../../core/config/env_config.dart';
import '../../../../core/network/http/app_http_client.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/entities/clinic_location_entity.dart';
import '../models/appointment_model.dart';
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
  Future<AppointmentModel> createEvent({
    required String? accessToken,
    required ClinicEntity? clinic,
    required ClinicLocationEntity? location,
    required DateTime? startTime,
    required EventStatus? eventStatus,
    required EventType? eventType,
  });
  Future<List<AppointmentModel>> getAppointments({
    required String? accessToken,
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

  @override
  Future<AppointmentModel> createEvent({
    required String? accessToken,
    required ClinicEntity? clinic,
    required ClinicLocationEntity? location,
    required DateTime? startTime,
    required EventStatus? eventStatus,
    required EventType? eventType,
  }) async {
    try {
      Logger.info('createEvent accessToken: $accessToken');

      final response = await appHttpClient.post(
        url: "${EnvConfig.akasiaCalendarApiUrl}/event",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'location_id': location?.id,
          'start_time': startTime?.toDateApi,
          'status': eventStatus?.name,
          'type': eventType?.name,
        },
      );
      Logger.success('createEvent response: $response');

      final data = (response.data['data'] is List)
          ? (response.data['data'] as List).first
          : {};

      return AppointmentModel(
        clinic: clinic?.name,
        location: location?.name,
        type: eventType,
        status: eventStatus,
        startTime: data['start_time'],
        endTime: data['end_time'],
      );
    } catch (error) {
      Logger.error('createEvent error: $error');

      rethrow;
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments({
    required String? accessToken,
  }) async {
    try {
      Logger.info('getAppointments accessToken: $accessToken');

      final response = await appHttpClient.get(
        url: "${EnvConfig.akasiaCalendarApiUrl}/appointments",
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      Logger.success('getAppointments response: $response');

      final List data =
          (response.data['data'] is List) ? response.data['data'] : [];

      return data.map((e) {
        return AppointmentModel.fromJson(e);
      }).toList();
    } catch (error) {
      Logger.error('getAppointments error: $error');

      rethrow;
    }
  }
}
