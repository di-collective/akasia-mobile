import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/eat_calendar_entity.dart';

part 'eat_calendar_state.dart';

class EatCalendarCubit extends Cubit<EatCalendarState> {
  EatCalendarCubit() : super(EatCalendarInitial());

  void init() {
    emit(EatCalendarInitial());
  }

  Future<void> changeMonth(DateTime month) async {
    try {
      emit(EatCalendarLoading());

      // TODO: implement changeMonth
      await Future.delayed(const Duration(seconds: 2));
    } catch (error) {
      emit(EatCalendarError(error: error));
    }
  }
}
