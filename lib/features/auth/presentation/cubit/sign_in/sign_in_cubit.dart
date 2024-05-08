import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/auth_type_extension.dart';
import '../../../domain/usecase/sign_in_use_case.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase signInUseCase;

  SignInCubit({
    required this.signInUseCase,
  }) : super(const SignInInitial(
          authType: AuthType.emailPassword,
        ));

  Future<UserCredential?> signIn({
    required AuthType authType,
    String? email,
    String? password,
  }) async {
    try {
      emit(const SignInLoading(
        authType: AuthType.emailPassword,
      ));

      final result = await signInUseCase.call(
        SignInParams(
          authType: authType,
          email: email,
          password: password,
        ),
      );

      emit(SignInLoaded(
        authType: AuthType.emailPassword,
        userCredential: result,
      ));

      return result;
    } catch (error) {
      emit(SignInError(
        error: error,
        authType: AuthType.emailPassword,
      ));

      rethrow;
    }
  }
}
