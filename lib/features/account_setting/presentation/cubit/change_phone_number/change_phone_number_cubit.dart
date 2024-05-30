import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_phone_number_state.dart';

class ChangePhoneNumberCubit extends Cubit<ChangePhoneNumberState> {
  ChangePhoneNumberCubit() : super(ChangePhoneNumberInitial());

  Future<void> changePassword({
    required String oldPhoneNumber,
    required String newPhoneNumber,
  }) async {
    try {
      emit(ChangePhoneNumberLoading());

      // TODO: call change phone number api

      await Future.delayed(const Duration(seconds: 2));

      emit(ChangePhoneNumberLoaded());
    } catch (error) {
      emit(ChangePhoneNumberError(error: error));

      rethrow;
    }
  }
}
