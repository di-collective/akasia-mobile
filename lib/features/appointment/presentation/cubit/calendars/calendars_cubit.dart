import 'package:akasia365mc/core/ui/extensions/date_time_extension.dart';
import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/calendar_appointment_entity.dart';
import '../../../domain/usecases/get_events_usecase.dart';

part 'calendars_state.dart';

class CalendarsCubit extends Cubit<CalendarsState> {
  final GetEventsUseCase getEventsUseCase;

  CalendarsCubit({
    required this.getEventsUseCase,
  }) : super(const CalendarsInitial());

  void init() {
    emit(const CalendarsInitial());
  }

  Future<void> initGetCalendars({
    required DateTime startTime,
    required String? locationId,
  }) async {
    emit(CalendarsLoading(
      locationId: locationId,
    ));

    try {
      final result = await getEventsUseCase(
        GetEventsUseCaseParams(
          locationId: locationId,
          startTime: startTime,
          endTime: startTime.lastDayOfMonth,
        ),
      );

      final monthYear = startTime.onlyYearMonth;

      emit(CalendarsLoaded(
        calendars: {
          monthYear: result,
        },
        locationId: locationId,
      ));
    } catch (error) {
      emit(CalendarsError(
        error: error,
        locationId: locationId,
      ));

      rethrow;
    }
  }

  Future<void> onChangedMonth({
    required DateTime month,
  }) async {
    final currentState = state;
    final locationId = currentState.locationId;

    try {
      final currentMonthYear = month.onlyYearMonth;

      if (currentState is CalendarsLoaded) {
        // check month already loaded or not
        final currentCalendars = currentState.calendars;
        final isMonthAlreadyLoaded = currentCalendars.containsKey(
          currentMonthYear,
        );
        if (isMonthAlreadyLoaded) {
          // if month already loaded, stop the function
          return;
        }
      } else {
        // emit loading state
        emit(CalendarsLoading(
          locationId: locationId,
        ));
      }

      // get calendars
      final result = await getEventsUseCase(
        GetEventsUseCaseParams(
          locationId: locationId,
          startTime: month.firstDayOfMonth,
          endTime: month.lastDayOfMonth,
        ),
      );

      // add new month to current calendars
      if (currentState is CalendarsLoaded) {
        final newCalendars = currentState.calendars;
        newCalendars.addAll({
          currentMonthYear: result,
        });

        emit(currentState.copyWith(
          calendars: newCalendars,
        ));
      } else {
        emit(CalendarsLoaded(
          calendars: {
            currentMonthYear: result,
          },
          locationId: locationId,
        ));
      }
    } catch (error) {
      if (state is! CalendarsLoaded) {
        // if the state is not CalendarsLoaded, emit CalendarsError
        emit(CalendarsError(
          error: error,
          locationId: locationId,
        ));
      }

      rethrow;
    }
  }
}
