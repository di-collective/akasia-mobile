import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/my_schedules/my_schedules_cubit.dart';

class MyScheduleDI {
  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    sl.registerFactory<MySchedulesCubit>(() {
      return MySchedulesCubit();
    });
  }
}
