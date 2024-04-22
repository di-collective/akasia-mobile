import 'package:injectable/injectable.dart';

import 'account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@lazySingleton
class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountState.initial());

  void onInit() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(const AccountState.loaded());
  }
}
