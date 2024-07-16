import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/daily_heart_rate/daily_heart_rate_cubit.dart';

class HeartRateDI {
  const HeartRateDI._();

  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<DailyHeartRateCubit>(() {
      return DailyHeartRateCubit();
    });
  }
}
