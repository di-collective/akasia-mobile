import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../../core/ui/extensions/string_extension.dart';
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

  List<AppointmentEntity> sortAppointments({
    required List<AppointmentEntity> appointments,
  }) {
    appointments.sort((a, b) {
      final statusA = a.status;
      final statusB = b.status;
      if (statusA == null || statusB == null) {
        return 0;
      }

      // sort by status
      final statusComparison = statusA.index.compareTo(statusB.index);
      if (statusComparison != 0) {
        return statusComparison;
      }

      final startTimeA = a.startTime;
      final startTimeB = b.startTime;
      if (startTimeA == null || startTimeB == null) {
        return 0;
      }

      // sort ascending by date for scheduled appointments
      if (statusA == EventStatus.scheduled) {
        return startTimeA.compareTo(startTimeB);
      }

      // sort descending by date for completed or cancelled appointments
      return startTimeB.compareTo(startTimeA);
    });

    return appointments;
  }

  Future<void> getMySchedules() async {
    try {
      if (state is AppointmentsLoading) {
        return;
      }

      emit(AppointmentsLoading());

      final result = await getAppointmentsUseCase(NoParams());

      // Sort the appointments
      final sortedAppointments = sortAppointments(
        appointments: result,
      );

      emit(AppointmentsLoaded(
        appointments: sortedAppointments,
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

      // Sort the appointments
      final sortedAppointments = sortAppointments(
        appointments: result,
      );

      emit(AppointmentsLoaded(
        appointments: sortedAppointments,
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
        final updatedAppointments = List<AppointmentEntity>.from(
          currentState.appointments,
        );

        // Find the correct position to insert the new event
        int insertIndex = updatedAppointments.indexWhere((appointment) {
          if (appointment.status == null || result.status == null) {
            return false;
          }

          // Compare status first
          final statusComparison =
              appointment.status!.index.compareTo(result.status!.index);
          if (statusComparison != 0) {
            return statusComparison > 0;
          }

          if (appointment.startTime == null || result.startTime == null) {
            return false;
          }

          // Compare start time
          final startTimeA = appointment.startTime?.toDateTime();
          final startTimeB = result.startTime?.toDateTime();
          if (startTimeA == null || startTimeB == null) {
            return false;
          }

          if (result.status == EventStatus.scheduled) {
            return startTimeA.isAfter(startTimeB);
          }

          return startTimeA.isBefore(startTimeB);
        });

        if (insertIndex == -1) {
          updatedAppointments.add(result);
        } else {
          updatedAppointments.insert(insertIndex, result);
        }

        emit(currentState.copyWith(
          appointments: updatedAppointments,
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
