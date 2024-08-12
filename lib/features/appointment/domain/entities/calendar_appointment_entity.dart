import 'package:equatable/equatable.dart';

import 'event_entity.dart';

class CalendarAppointmentEntity extends Equatable {
  final int? capacity;
  final List<EventEntity>? events;

  const CalendarAppointmentEntity({
    this.capacity,
    this.events,
  });

  @override
  List<Object?> get props => [
        capacity,
        events,
      ];
}
