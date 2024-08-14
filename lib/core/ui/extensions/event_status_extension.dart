enum EventStatus {
  scheduled,
  completed,
  cancelled,
}

extension EventStatusExtension on EventStatus {
  static EventStatus? fromString({
    required String? status,
    required DateTime? startTime,
  }) {
    final value = status?.toLowerCase();
    if (value == null) {
      return null;
    }

    switch (value) {
      case 'scheduled':
        // if the event is scheduled and the start time is in the past
        // then it should be considered as completed
        if (startTime != null && startTime.isBefore(DateTime.now())) {
          return EventStatus.completed;
        }

        return EventStatus.scheduled;
      case 'completed':
        return EventStatus.completed;
      case 'cancelled':
        return EventStatus.cancelled;
    }

    return null;
  }
}
