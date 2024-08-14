import '../../domain/entities/calendar_appointment_entity.dart';
import 'event_model.dart';

class CalendarAppointmentModel extends CalendarAppointmentEntity {
  const CalendarAppointmentModel({
    super.capacity,
    super.events,
  });

  factory CalendarAppointmentModel.fromJson(Map<String, dynamic> json) {
    return CalendarAppointmentModel(
      capacity: json['capacity'],
      events: (json['events'] is List)
          ? (json['events'] as List).map((e) {
              return EventModel.fromJson(e);
            }).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'events': events?.map((e) {
        return (e as EventModel).toJson();
      }).toList(),
    };
  }
}
