import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      emit(ChangePasswordLoading());

      // TODO: call change password api

      await Future.delayed(const Duration(seconds: 2));

      emit(ChangePasswordLoaded());
    } catch (error) {
      emit(ChangePasswordError(error: error));

      rethrow;
    }
  }
}
