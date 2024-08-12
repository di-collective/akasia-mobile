enum EventType {
  appointment,
  holiday,
}

extension EventTypeExtension on EventType {
  static EventType? fromString({
    required String? type,
  }) {
    final value = type?.toLowerCase();
    if (value == null) {
      return null;
    }

    switch (value) {
      case 'holiday':
        return EventType.holiday;
      case 'appointment':
        return EventType.appointment;
    }

    return null;
  }
}
