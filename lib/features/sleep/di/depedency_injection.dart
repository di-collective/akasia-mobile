import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/daily_sleep/daily_sleep_cubit.dart';

class SleepDI {
  const SleepDI._();

  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<DailySleepCubit>(() {
      return DailySleepCubit();
    });
  }
}
