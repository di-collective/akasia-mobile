import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_schedules_state.dart';

class MySchedulesCubit extends Cubit<MySchedulesState> {
  MySchedulesCubit() : super(MySchedulesInitial());

  Future<void> getMySchedules() async {
    try {
      emit(MySchedulesLoading());

      // TODO: implement getSchedules
      final result = await Future.delayed(
        const Duration(seconds: 3),
        () => [],
      );

      emit(MySchedulesLoaded(
        schedules: result,
      ));
    } catch (error) {
      emit(MySchedulesError(
        error: error,
      ));
    }
  }

  Future<void> refreshSchedules() async {
    try {
      if (state is MySchedulesLoading) {
        return;
      } else if (state is! MySchedulesLoaded) {
        emit(MySchedulesLoading());
      }

      // TODO: implement getSchedules
      final result = await Future.delayed(
        const Duration(seconds: 3),
        () => [
          1,
          2,
          3,
          4,
          5,
        ],
      );

      emit(MySchedulesLoaded(
        schedules: result,
      ));
    } catch (error) {
      if (state is! MySchedulesLoaded) {
        emit(MySchedulesError(
          error: error,
        ));
      }

      rethrow;
    }
  }
}
