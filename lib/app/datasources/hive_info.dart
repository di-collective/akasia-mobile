import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/ui/extensions/hive_box_extension.dart';
import '../../features/health/domain/entities/heart_rate_activity_entity.dart';
import '../../features/health/domain/entities/nutrition_activity_entity.dart';
import '../../features/health/domain/entities/sleep_activity_entity.dart';
import '../../features/health/domain/entities/steps_activity_entity.dart';
import '../../features/health/domain/entities/workout_activity_entity.dart';

class HiveInfo {
  const HiveInfo._();

  static Future<void> init() async {
    // init hive
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(
      directory.path,
    );

    // register adapters
    Hive.registerAdapter(StepsActivityEntityAdapter());
    Hive.registerAdapter(SleepActivityEntityAdapter());
    Hive.registerAdapter(HeartRateActivityEntityAdapter());
    Hive.registerAdapter(WorkoutActivityEntityAdapter());
    Hive.registerAdapter(NutritionActivityEntityAdapter());

    // open box
    await Future.wait(HiveBox.values.map((e) {
      return e.openBox();
    }));
  }
}
