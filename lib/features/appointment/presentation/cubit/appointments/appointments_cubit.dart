import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../../core/ui/extensions/event_type_extension.dart';
import '../../../domain/usecases/create_event_usecase.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final CreateEventUseCase createEventUseCase;

  AppointmentsCubit({
    required this.createEventUseCase,
  }) : super(AppointmentsInitial());

  Future<void> getMySchedules() async {
    try {
      emit(AppointmentsLoading());

      // TODO: implement getSchedules
      final result = await Future.delayed(
        const Duration(seconds: 3),
        () => [],
      );

      emit(AppointmentsLoaded(
        schedules: result,
      ));
    } catch (error) {
      emit(AppointmentsError(
        error: error,
      ));
    }
  }

  Future<void> refreshSchedules() async {
    try {
      if (state is AppointmentsLoading) {
        return;
      } else if (state is! AppointmentsLoaded) {
        emit(AppointmentsLoading());
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

      emit(AppointmentsLoaded(
        schedules: result,
      ));
    } catch (error) {
      if (state is! AppointmentsLoaded) {
        emit(AppointmentsError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  Future<void> createEvent({
    required String? locationId,
    required DateTime? startTime,
  }) async {
    try {
      await createEventUseCase(
        CreateEventUseCaseParams(
          locationId: locationId,
          startTime: startTime,
          eventType: EventType.appointment,
          eventStatus: EventStatus.scheduled,
        ),
      );
    } catch (_) {
      rethrow;
    }
  }
}
