import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../domain/usecases/update_profile_usecase.dart';

part 'edit_emergency_contact_state.dart';

class EditEmergencyContactCubit extends Cubit<EditEmergencyContactState> {
  final UpdateProfileUseCase updateProfileUseCase;

  EditEmergencyContactCubit({
    required this.updateProfileUseCase,
  }) : super(EditEmergencyContactInitial());

  Future<void> editEmergencyContact({
    required String? userId,
    required String? ecRelation,
    required String? ecName,
    required String? ecCountryCode,
    required String? ecPhone,
  }) async {
    try {
      emit(EditEmergencyContactLoading());

      await updateProfileUseCase(
        UpdateProfileParams(
          profile: ProfileEntity(
            userId: userId,
            ecRelation: ecRelation,
            ecName: ecName,
            ecCountryCode: ecCountryCode,
            ecPhone: ecPhone,
          ),
        ),
      );

      emit(EditEmergencyContactLoaded());
    } catch (error) {
      emit(EditEmergencyContactError(error: error));

      rethrow;
    }
  }
}
