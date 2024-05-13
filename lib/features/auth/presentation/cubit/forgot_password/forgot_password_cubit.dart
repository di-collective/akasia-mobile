import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/reset_password_usecase.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit({
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordInitial());

  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      emit(ForgotPasswordLoading());

      await resetPasswordUseCase(
        ResetPasswordParams(email: email),
      );

      emit(ForgotPasswordLoaded());
    } catch (error) {
      emit(ForgotPasswordError(
        error: error,
      ));
    }
  }
}
