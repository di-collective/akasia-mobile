import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/appointment_entity.dart';
import '../../../domain/entities/clinic_entity.dart';
import '../../../domain/entities/clinic_location_entity.dart';
import '../../../domain/usecases/create_event_usecase.dart';
import '../../../domain/usecases/get_appointments_usecase.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final CreateEventUseCase createEventUseCase;

  AppointmentsCubit({
    required this.getAppointmentsUseCase,
    required this.createEventUseCase,
  }) : super(AppointmentsInitial());

  Future<void> getMySchedules() async {
    try {
      emit(AppointmentsLoading());

      final result = await getAppointmentsUseCase(NoParams());

      emit(AppointmentsLoaded(
        appointments: result,
      ));
    } catch (error) {
      emit(AppointmentsError(
        error: error,
      ));
    }
  }

  Future<void> refreshSchedules() async {
    final currentState = state;

    try {
      if (currentState is AppointmentsLoading) {
        return;
      }

      if (currentState is! AppointmentsLoaded) {
        emit(AppointmentsLoading());
      }

      final result = await getAppointmentsUseCase(NoParams());

      emit(AppointmentsLoaded(
        appointments: result,
      ));
    } catch (error) {
      if (currentState is! AppointmentsLoaded) {
        emit(AppointmentsError(
          error: error,
        ));
      }

      rethrow;
    }
  }

  Future<void> createEvent({
    required ClinicEntity? clinic,
    required ClinicLocationEntity? location,
    required DateTime? startTime,
  }) async {
    try {
      final result = await createEventUseCase(
        CreateEventUseCaseParams(
          clinic: clinic,
          location: location,
          startTime: startTime,
          eventType: EventType.appointment,
          eventStatus: EventStatus.scheduled,
        ),
      );

      final currentState = state;

      if (currentState is AppointmentsLoaded) {
        emit(currentState.copyWith(
          appointments: [
            ...currentState.appointments,
            result,
          ],
        ));
      } else {
        emit(AppointmentsLoaded(
          appointments: [result],
        ));
      }
    } catch (_) {
      rethrow;
    }
  }
}
