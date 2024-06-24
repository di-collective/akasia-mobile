import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'fill_personal_information_state.dart';

class FillPersonalInformationCubit extends Cubit<FillPersonalInformationState> {
  FillPersonalInformationCubit() : super(FillPersonalInformationInitial());

  Future<void> fillPersonalInformation() async {
    try {
      emit(FillPersonalInformationLoading());

      // TODO: Connect to API
      await Future.delayed(const Duration(seconds: 2));

      emit(FillPersonalInformationLoaded());
    } catch (error) {
      emit(FillPersonalInformationError(error: error));

      rethrow;
    }
  }
}
