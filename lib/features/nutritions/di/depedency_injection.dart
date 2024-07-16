import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/daily_nutritions/daily_nutritions_cubit.dart';

class NutritionsDI {
  const NutritionsDI._();

  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<DailyNutritionsCubit>(() {
      return DailyNutritionsCubit();
    });
  }
}
