import 'package:hive/hive.dart';

enum HiveBox {
  activity,
}

extension HiveBoxExtension on HiveBox {
  String get name {
    switch (this) {
      case HiveBox.activity:
        return 'activity_box';
    }
  }

  Box<E> box<E>() {
    switch (this) {
      case HiveBox.activity:
        return Hive.box(name);
    }
  }

  Future<Box<E>> openBox<E>() async {
    return await Hive.openBox(name);
  }
}
