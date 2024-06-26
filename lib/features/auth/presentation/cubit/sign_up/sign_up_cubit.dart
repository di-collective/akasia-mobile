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
          authType: AuthType.email,
        ));

  Future<UserCredential?> signUp({
    required AuthType authType,
    String? eKtp,
    String? name,
    String? email,
    required String phoneCode,
    required String phoneNumber,
    String? password,
  }) async {
    try {
      emit(SignUpLoading(
        authType: authType,
      ));

      final result = await signUpUseCase.call(
        SignUpParams(
          authType: authType,
          name: name,
          eKtp: eKtp,
          email: email,
          phoneCode: phoneCode,
          phoneNumber: phoneNumber,
          password: password,
        ),
      );

      emit(SignUpLoaded(
        authType: authType,
        userCredential: result,
      ));

      return result;
    } catch (error) {
      emit(SignUpError(
        error: error,
        authType: authType,
      ));

      rethrow;
    }
  }
}
