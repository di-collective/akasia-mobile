import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/search_foods/search_foods_cubit.dart';

class DietPlanDI {
  const DietPlanDI._();

  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    sl.registerFactory(() {
      return SearchFoodsCubit();
    });
  }
}
