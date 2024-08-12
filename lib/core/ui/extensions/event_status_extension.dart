enum EventStatus {
  scheduled,
  completed,
  cancelled,
}

extension EventStatusExtension on EventStatus {
  static EventStatus? fromString({
    required String? status,
  }) {
    final value = status?.toLowerCase();
    if (value == null) {
      return null;
    }

    switch (value) {
      case 'scheduled':
        return EventStatus.scheduled;
      case 'completed':
        return EventStatus.completed;
      case 'cancelled':
        return EventStatus.cancelled;
    }

    return null;
  }
}
