import '../../../core/utils/service_locator.dart';
import '../presentation/cubit/daily_workouts/daily_workouts_cubit.dart';

class WorkoutsDI {
  const WorkoutsDI._();

  static void inject() {
    // cubits
    _injectCubits();
  }

  static void _injectCubits() {
    // cubits
    sl.registerFactory<DailyWorkoutsCubit>(() {
      return DailyWorkoutsCubit();
    });
  }
}
