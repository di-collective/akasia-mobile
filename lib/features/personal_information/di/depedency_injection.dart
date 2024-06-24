import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/fill_personal_information/fill_personal_information_cubit.dart';

class PersonalInformationDI {
  static void inject() {
    _injectCubits();
  }

  static void _injectCubits() {
    sl.registerFactory<FillPersonalInformationCubit>(() {
      return FillPersonalInformationCubit();
    });
  }
}
