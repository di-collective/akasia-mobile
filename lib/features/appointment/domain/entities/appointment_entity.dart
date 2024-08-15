import 'package:equatable/equatable.dart';

import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';

class AppointmentEntity extends Equatable {
  final String? clinic;
  final String? location;
  final String? startTime;
  final String? endTime;
  final EventType? type;
  final EventStatus? status;

  const AppointmentEntity({
    this.clinic,
    this.location,
    this.startTime,
    this.endTime,
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [
        clinic,
        location,
        startTime,
        endTime,
        type,
        status,
      ];
}
