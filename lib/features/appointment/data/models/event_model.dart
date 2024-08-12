import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    super.clinic,
    super.location,
    super.startTime,
    super.endTime,
    super.type,
    super.status,
    super.eventType,
  });

  factory EventModel.fromJson(
    Map<String, dynamic> json, {
    int? capacity,
  }) {
    return EventModel(
      clinic: json['clinic'],
      location: json['location'],
      startTime: DynamicExtension(json['start_time']).dynamicToDateTime,
      endTime: DynamicExtension(json['end_time']).dynamicToDateTime,
      type: json['type'],
      status: json['status'],
      eventType: EventTypeExtension.fromString(
        type: json['type'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic': clinic,
      'location': location,
      'start_time': startTime,
      'end_time': endTime,
      'type': type,
      'status': status,
    };
  }
}
