import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_appointment_state.dart';

class CreateAppointmentCubit extends Cubit<CreateAppointmentState> {
  CreateAppointmentCubit() : super(CreateAppointmentInitial());

  Future<void> createAppointment({
    required String? clinicId,
    required String? clinicLocationId,
    required DateTime? date,
    required TimeOfDay? time,
  }) async {
    try {
      emit(CreateAppointmentLoading());

      // TODO: Implement create appointment logic
      await Future.delayed(const Duration(seconds: 2));

      emit(CreateAppointmentLoaded());
    } catch (error) {
      emit(CreateAppointmentError(error: error));

      rethrow;
    }
  }
}
