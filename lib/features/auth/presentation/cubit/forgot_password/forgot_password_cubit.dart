import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/forgot_password_usecase.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordCubit({
    required this.forgotPasswordUseCase,
  }) : super(ForgotPasswordInitial());

  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      emit(ForgotPasswordLoading());

      await forgotPasswordUseCase(
        ForgotPasswordParams(email: email),
      );

      emit(ForgotPasswordLoaded());
    } catch (error) {
      emit(ForgotPasswordError(
        error: error,
      ));

      rethrow;
    }
  }
}
