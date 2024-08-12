enum EventType {
  appointment,
  holiday,
}

extension EventTypeExtension on EventType {
  static EventType? fromString({
    required String? type,
    DateTime? date,
  }) {
    final value = type?.toLowerCase();
    if (value == null) {
      return null;
    }

    // TODO: validate date is more then working hour

    switch (value) {
      case 'holiday':
        return EventType.holiday;
      case 'appointment':
        return EventType.appointment;
    }

    return null;
  }
}
