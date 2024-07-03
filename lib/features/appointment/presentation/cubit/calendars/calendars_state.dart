part of 'calendars_cubit.dart';

sealed class CalendarsState extends Equatable {
  const CalendarsState();

  @override
  List<Object> get props => [];
}

final class CalendarsInitial extends CalendarsState {}

final class CalendarsLoading extends CalendarsState {}

final class CalendarsLoaded extends CalendarsState {
  final List<AppointmentMonthEntity> calendars;

  const CalendarsLoaded({
    required this.calendars,
  });

  CalendarsLoaded copyWith({
    List<AppointmentMonthEntity>? calendars,
  }) {
    return CalendarsLoaded(
      calendars: calendars ?? this.calendars,
    );
  }

  @override
  List<Object> get props => [calendars];
}

final class CalendarsError extends CalendarsState {
  final Object error;

  const CalendarsError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
