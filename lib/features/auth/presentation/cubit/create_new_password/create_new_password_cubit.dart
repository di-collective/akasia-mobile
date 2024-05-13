import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/confirm_password_reset_usecase.dart';

part 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final ConfirmPasswordResetUseCase confirmPasswordResetUseCase;

  CreateNewPasswordCubit({
    required this.confirmPasswordResetUseCase,
  }) : super(CreateNewPasswordInitial());

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      emit(CreateNewPasswordLoading());

      await confirmPasswordResetUseCase.call(
        ConfirmPasswordResetParams(
          code: code,
          newPassword: newPassword,
        ),
      );

      emit(CreateNewPasswordLoaded());
    } catch (error) {
      emit(CreateNewPasswordError(error: error));
    }
  }
}
