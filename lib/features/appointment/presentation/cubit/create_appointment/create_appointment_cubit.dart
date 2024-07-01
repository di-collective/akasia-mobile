import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_appointment_state.dart';

class CreateAppointmentCubit extends Cubit<CreateAppointmentState> {
  CreateAppointmentCubit() : super(CreateAppointmentInitial());

  Future<void> createAppointment() async {
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
