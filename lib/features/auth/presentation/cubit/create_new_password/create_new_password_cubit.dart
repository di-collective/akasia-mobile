import 'package:akasia365mc/features/auth/domain/usecase/update_password_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/confirm_password_reset_usecase.dart';

part 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final ConfirmPasswordResetUseCase confirmPasswordResetUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  CreateNewPasswordCubit({
    required this.confirmPasswordResetUseCase,
    required this.updatePasswordUseCase,
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

      rethrow;
    }
  }

  Future<void> updatePassword({
    required String userId,
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      emit(CreateNewPasswordLoading());

      await updatePasswordUseCase.call(
        UpdatePasswordUseCaseParams(
          userId: userId,
          resetToken: resetToken,
          newPassword: newPassword,
        ),
      );

      emit(CreateNewPasswordLoaded());
    } catch (error) {
      emit(CreateNewPasswordError(error: error));

      rethrow;
    }
  }
}
