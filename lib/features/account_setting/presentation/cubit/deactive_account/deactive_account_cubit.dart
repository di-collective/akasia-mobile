import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/extensions/deactive_account_reason_extension.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../auth/domain/usecase/sign_out_use_case.dart';

part 'deactive_account_state.dart';

class DeactiveAccountCubit extends Cubit<DeactiveAccountState> {
  final SignOutUseCase signOutUseCase;

  DeactiveAccountCubit({
    required this.signOutUseCase,
  }) : super(DeactiveAccountInitial());

  Future<void> deactiveAccount({
    required DeactiveAccountReason reason,
  }) async {
    try {
      emit(DeactiveAccountLoading());

      // TODO: call deactive account api

      await Future.delayed(const Duration(seconds: 2));

      // sign out
      await signOutUseCase.call(NoParams());

      emit(DeactiveAccountLoaded());
    } catch (error) {
      emit(DeactiveAccountError(error: error));

      rethrow;
    }
  }
}
