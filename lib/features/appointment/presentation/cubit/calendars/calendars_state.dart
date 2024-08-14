part of 'calendars_cubit.dart';

sealed class CalendarsState extends Equatable {
  final String? locationId;

  const CalendarsState({
    this.locationId,
  });

  @override
  List<Object?> get props => [
        locationId,
      ];
}

final class CalendarsInitial extends CalendarsState {
  const CalendarsInitial({
    super.locationId,
  });

  @override
  List<Object?> get props => [
        locationId,
      ];
}

final class CalendarsLoading extends CalendarsState {
  const CalendarsLoading({
    super.locationId,
  });

  @override
  List<Object?> get props => [
        locationId,
      ];
}

final class CalendarsLoaded extends CalendarsState {
  final Map<DateTime, CalendarAppointmentEntity> calendars;

  const CalendarsLoaded({
    required this.calendars,
    super.locationId,
  });

  CalendarsLoaded copyWith({
    Map<DateTime, CalendarAppointmentEntity>? calendars,
    String? locationId,
  }) {
    return CalendarsLoaded(
      calendars: calendars ?? this.calendars,
      locationId: locationId ?? this.locationId,
    );
  }

  @override
  List<Object?> get props => [
        calendars,
        locationId,
      ];
}

final class CalendarsError extends CalendarsState {
  final Object error;

  const CalendarsError({
    required this.error,
    super.locationId,
  });

  @override
  List<Object?> get props => [
        error,
        locationId,
      ];
}
