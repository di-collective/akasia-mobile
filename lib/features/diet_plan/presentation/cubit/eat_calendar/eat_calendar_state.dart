part of 'eat_calendar_cubit.dart';

sealed class EatCalendarState extends Equatable {
  const EatCalendarState();

  @override
  List<Object?> get props => [];
}

final class EatCalendarInitial extends EatCalendarState {}

final class EatCalendarLoading extends EatCalendarState {}

final class EatCalendarLoaded extends EatCalendarState {
  final DateTime? selectedDate;
  final Map<int, List<EatCalendarEntity>> eatCalendar;

  const EatCalendarLoaded({
    required this.selectedDate,
    required this.eatCalendar,
  });

  EatCalendarLoaded copyWith({
    DateTime? selectedDate,
    Map<int, List<EatCalendarEntity>>? eatCalendar,
  }) {
    return EatCalendarLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      eatCalendar: eatCalendar ?? this.eatCalendar,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        eatCalendar,
      ];
}

final class EatCalendarError extends EatCalendarState {
  final Object error;

  const EatCalendarError({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
