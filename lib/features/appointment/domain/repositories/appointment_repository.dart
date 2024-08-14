import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../entities/calendar_appointment_entity.dart';

abstract class AppointmentRepository {
  Future<CalendarAppointmentEntity> getEvents({
    required String? locationId,
    required DateTime? startTime,
    required DateTime? endTime,
    int? page,
    int? limit,
  });
  Future<void> createEvent({
    required String? locationId,
    required DateTime? startTime,
    required EventStatus? eventStatus,
    required EventType? eventType,
  });
}
