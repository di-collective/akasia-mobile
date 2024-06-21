import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/bottom_navigation/bottom_navigation_cubit.dart';

class MainDI {
  MainDI._();

  static Future<void> inject() async {
    // cubit
    _injectCubits();
  }

  static void _injectCubits() {
    sl.registerFactory<BottomNavigationCubit>(() {
      return BottomNavigationCubit();
    });
  }
}
