enum EventType {
  appointment,
  holiday,
}

extension EventTypeExtension on EventType {
  static EventType? fromString({
    required String? eventType,
  }) {
    if (eventType == null) {
      return null;
    }

    final type = eventType.toLowerCase();
    switch (type) {
      case 'holiday':
        return EventType.holiday;
      case 'appointment':
        return EventType.appointment;
    }

    return null;
  }
}
