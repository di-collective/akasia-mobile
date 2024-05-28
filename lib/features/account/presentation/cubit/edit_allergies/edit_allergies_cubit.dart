import 'package:akasia365mc/features/account/data/models/allergy_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_allergies_state.dart';

class EditAllergiesCubit extends Cubit<EditAllergiesState> {
  EditAllergiesCubit() : super(EditAllergiesInitial());

  Future<void> editAllergies({
    required List<AllergyModel> allergies,
  }) async {
    try {
      emit(EditAllergiesLoading());

      // TODO: implement editAllergies
      await Future.delayed(const Duration(seconds: 1));

      emit(EditAllergiesLoaded());
    } catch (error) {
      emit(EditAllergiesError(error: error));

      rethrow;
    }
  }
}
