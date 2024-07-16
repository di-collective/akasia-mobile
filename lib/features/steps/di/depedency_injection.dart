import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/daily_steps/daily_steps_cubit.dart';

class StepsDI {
  const StepsDI._();

  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<DailyStepsCubit>(() {
      return DailyStepsCubit();
    });
  }
}
