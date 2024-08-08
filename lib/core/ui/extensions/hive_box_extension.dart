import 'package:hive/hive.dart';

enum HiveBox {
  steps,
  sleep,
  heartRate,
  workout,
  nutrition,
}

extension HiveBoxExtension on HiveBox {
  String get name {
    switch (this) {
      case HiveBox.steps:
        return 'steps';
      case HiveBox.sleep:
        return 'sleep';
      case HiveBox.heartRate:
        return 'heart_rate';
      case HiveBox.workout:
        return 'workout';
      case HiveBox.nutrition:
        return 'nutrition';
    }
  }

  Box<E> box<E>() {
    switch (this) {
      case HiveBox.steps:
      case HiveBox.sleep:
      case HiveBox.heartRate:
      case HiveBox.workout:
      case HiveBox.nutrition:
        return Hive.box<E>(name);
    }
  }

  Future<Box<E>> openBox<E>() async {
    return await Hive.openBox(name);
  }
}
