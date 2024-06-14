import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../domain/usecases/update_profile_usecase.dart';

part 'edit_allergies_state.dart';

class EditAllergiesCubit extends Cubit<EditAllergiesState> {
  final UpdateProfileUseCase updateProfileUseCase;

  EditAllergiesCubit({
    required this.updateProfileUseCase,
  }) : super(EditAllergiesInitial());

  Future<void> editAllergies({
    required String? userId,
    required String? allergies,
  }) async {
    try {
      emit(EditAllergiesLoading());

      await updateProfileUseCase.call(
        UpdateProfileParams(
          profile: ProfileEntity(
            userId: userId,
            allergies: allergies,
          ),
        ),
      );

      emit(EditAllergiesLoaded());
    } catch (error) {
      emit(EditAllergiesError(error: error));

      rethrow;
    }
  }
}
