import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../domain/usecases/update_profile_usecase.dart';

part 'edit_information_state.dart';

class EditInformationCubit extends Cubit<EditInformationState> {
  final UpdateProfileUseCase updateProfileUseCase;

  EditInformationCubit({
    required this.updateProfileUseCase,
  }) : super(EditInformationInitial());

  Future<void> saveEditInformation({
    required ProfileEntity profile,
  }) async {
    emit(EditInformationLoading());

    try {
      await updateProfileUseCase.call(
        UpdateProfileParams(
          profile: profile,
        ),
      );

      emit(EditInformationLoaded());
    } catch (error) {
      emit(EditInformationError(error: error));

      rethrow;
    }
  }
}
