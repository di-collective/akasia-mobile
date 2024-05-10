import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/auth_type_extension.dart';
import '../../../domain/usecase/sign_up_usecase.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpCubit({
    required this.signUpUseCase,
  }) : super(const SignUpInitial(
          authType: AuthType.emailPassword,
        ));

  Future<UserCredential?> signUp({
    required AuthType authType,
    String? email,
    String? password,
  }) async {
    try {
      emit(SignUpLoading(
        authType: authType,
      ));

      final result = await signUpUseCase.call(
        SignUpParams(
          authType: authType,
          email: email,
          password: password,
        ),
      );

      emit(SignUpLoaded(
        authType: AuthType.emailPassword,
        userCredential: result,
      ));

      return result;
    } catch (error) {
      emit(SignUpError(
        error: error,
        authType: AuthType.emailPassword,
      ));

      rethrow;
    }
  }
}
