import 'package:equatable/equatable.dart';

import '../../../../core/ui/extensions/event_type_extension.dart';

class EventEntity extends Equatable {
  final String? clinic;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? type;
  final String? status;
  final EventType? eventType;

  const EventEntity({
    this.clinic,
    this.location,
    this.startTime,
    this.endTime,
    this.type,
    this.status,
    this.eventType,
  });

  @override
  List<Object?> get props => [
        clinic,
        location,
        startTime,
        endTime,
        type,
        status,
        eventType,
      ];
}
