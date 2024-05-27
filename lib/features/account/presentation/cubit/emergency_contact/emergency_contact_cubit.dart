import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../data/models/emergency_contact_model.dart';
import '../../../domain/usecases/get_emergency_contact_usecase.dart';

part 'emergency_contact_state.dart';

class EmergencyContactCubit extends Cubit<EmergencyContactState> {
  final GetEmergencyContactUseCase getEmergencyContactUseCase;

  EmergencyContactCubit({
    required this.getEmergencyContactUseCase,
  }) : super(EmergencyContactInitial());

  Future<void> getEmergencyContact() async {
    try {
      emit(EmergencyContactLoading());

      final emergencyContact = await getEmergencyContactUseCase(NoParams());

      emit(EmergencyContactLoaded(
        emergencyContact: emergencyContact,
      ));
    } catch (error) {
      emit(EmergencyContactError(error: error));

      rethrow;
    }
  }
}
