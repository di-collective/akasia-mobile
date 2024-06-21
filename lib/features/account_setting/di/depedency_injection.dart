import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/change_password/change_password_cubit.dart';
import '../presentation/cubit/change_phone_number/change_phone_number_cubit.dart';
import '../presentation/cubit/deactive_account/deactive_account_cubit.dart';

class AccountSettingDI {
  static void inject() {
    // Cubit
    _injectCubits();
  }

  static void _injectCubits() {
    sl.registerFactory<ChangePasswordCubit>(() {
      return ChangePasswordCubit();
    });
    sl.registerFactory<ChangePhoneNumberCubit>(() {
      return ChangePhoneNumberCubit();
    });
    sl.registerFactory<DeactiveAccountCubit>(() {
      return DeactiveAccountCubit(
        signOutUseCase: sl(),
      );
    });
  }
}
