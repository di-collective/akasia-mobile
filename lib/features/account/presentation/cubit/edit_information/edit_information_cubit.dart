import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_information_state.dart';

class EditInformationCubit extends Cubit<EditInformationState> {
  EditInformationCubit() : super(EditInformationInitial());

  Future<void> saveEditInformation() async {
    emit(EditInformationLoading());

    try {
      // TODO: Save edit information to the server
      await Future.delayed(const Duration(seconds: 5));

      emit(EditInformationLoaded());
    } catch (error) {
      emit(EditInformationError(error: error));
    }
  }
}
