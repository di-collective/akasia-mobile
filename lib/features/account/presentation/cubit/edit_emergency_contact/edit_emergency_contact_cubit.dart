import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/edit_emergency_contact_usecase.dart';

part 'edit_emergency_contact_state.dart';

class EditEmergencyContactCubit extends Cubit<EditEmergencyContactState> {
  final EditEmergencyContactUseCase editEmergencyContactUseCase;

  EditEmergencyContactCubit({
    required this.editEmergencyContactUseCase,
  }) : super(EditEmergencyContactInitial());

  Future<void> editEmergencyContact({
    required EditEmergencyContactUseCaseParams params,
  }) async {
    try {
      emit(EditEmergencyContactLoading());

      await editEmergencyContactUseCase(params);

      emit(EditEmergencyContactLoaded());
    } catch (error) {
      emit(EditEmergencyContactError(error: error));

      rethrow;
    }
  }
}
