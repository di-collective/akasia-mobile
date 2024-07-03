import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/appointment_date_entity.dart';
import '../../../domain/entities/appointment_month_entity.dart';

part 'calendars_state.dart';

class CalendarsCubit extends Cubit<CalendarsState> {
  CalendarsCubit() : super(CalendarsInitial());

  void init() {
    emit(CalendarsInitial());
  }

  Future<void> initGetCalendars({
    required DateTime month,
  }) async {
    emit(CalendarsLoading());

    try {
      // TODO: Implement getCalendars
      final result = await Future.delayed(const Duration(seconds: 2)).then(
        (value) => mockMonth(
          month: month,
        ),
      );

      emit(CalendarsLoaded(
        calendars: [
          result,
        ],
      ));
    } catch (error) {
      emit(CalendarsError(
        error: error,
      ));

      rethrow;
    }
  }

  Future<AppointmentMonthEntity?> onChangedMonth({
    required DateTime month,
  }) async {
    try {
      final state = this.state;
      if (state is! CalendarsLoaded) {
        return null;
      }

      // check month already loaded or not
      final currentMonth = month.month;
      final isMonthAlreadyLoaded = state.calendars.any((element) {
        return element.month?.month == currentMonth;
      });
      if (isMonthAlreadyLoaded) {
        return null;
      }

      // TODO: Implement getCalendars
      final result = await Future.delayed(const Duration(seconds: 2)).then(
        (value) => mockMonth(
          month: month,
        ),
      );

      return result;
    } catch (error) {
      if (state is! CalendarsLoaded) {
        // if the state is not CalendarsLoaded, emit CalendarsError
        emit(CalendarsError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  void addLoadedCalendar({
    required AppointmentMonthEntity calendar,
  }) {
    final state = this.state;
    if (state is! CalendarsLoaded) {
      return;
    }

    emit(
      CalendarsLoaded(
        calendars: [
          ...state.calendars,
          calendar,
        ],
      ),
    );
  }
}

AppointmentMonthEntity mockMonth({
  required DateTime month,
}) {
  return AppointmentMonthEntity(
    month: month,
    status: LoadStatus.loaded,
    dates: [
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 1),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 2),
        status: AppointmentDateStatus.booked,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 3),
        status: AppointmentDateStatus.unavailable,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 4),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 5),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 6),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 7),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 8),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 9),
        status: AppointmentDateStatus.booked,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 10),
        status: AppointmentDateStatus.booked,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 11),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 12),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 13),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 14),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 15),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 16),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 17),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 18),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 19),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 20),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 21),
        status: AppointmentDateStatus.booked,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 22),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 23),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 24),
        status: AppointmentDateStatus.booked,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 25),
        status: AppointmentDateStatus.booked,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 26),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 27),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 28),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 29),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 30),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
      AppointmentDateEntity(
        date: DateTime(month.year, month.month, 31),
        status: AppointmentDateStatus.available,
        availableSlots: 16,
      ),
    ],
  );
}
