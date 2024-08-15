import '../../../../core/ui/extensions/dynamic_extension.dart';

import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.clinic,
    super.location,
    super.startTime,
    super.endTime,
    super.type,
    super.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      clinic: json['clinic'],
      location: json['location'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      type: EventTypeExtension.fromString(
        type: json['type'],
      ),
      status: EventStatusExtension.fromString(
        status: json['status'],
        startTime: DynamicExtension(json['start_time']).dynamicToDateTime,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic': clinic,
      'location': location,
      'start_time': startTime,
      'end_time': endTime,
      'type': type?.name,
      'status': status?.name,
    };
  }
}
