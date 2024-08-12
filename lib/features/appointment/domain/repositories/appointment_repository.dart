import '../entities/calendar_appointment_entity.dart';

abstract class AppointmentRepository {
  Future<CalendarAppointmentEntity> getEvents({
    required String? locationId,
    required DateTime? startTime,
    required DateTime? endTime,
    int? page,
    int? limit,
  });
}
