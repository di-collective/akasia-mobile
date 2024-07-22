import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../core/flavors/flavor_name_key.dart';
import '../core/flavors/flavor_type_extension.dart';
import '../core/ui/extensions/hive_box_extension.dart';
import '../features/health/domain/entities/sleep_activity_entity.dart';
import '../features/health/domain/entities/steps_activity_entity.dart';
import 'app.dart';
import 'di/depedency_injection.dart' as di;
import 'observers/bloc_observer_info.dart';

Future<void> main() async {
  // Initialize app
  await init();

  runApp(const App());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // bloc observer
  Bloc.observer = BlocObserverInfo();

  // set orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // firebase init
  await Firebase.initializeApp();

  // flavor config
  FlavorConfig(
    name: "DEVELOPMENT",
    variables: {
      FlavorNameKey.type: FlavorType.development,
    },
  );

  // init hive
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(
    directory.path,
  );

  // register adapters
  Hive.registerAdapter(StepsActivityEntityAdapter());
  Hive.registerAdapter(SleepActivityEntityAdapter());

  // open box
  await Future.wait(HiveBox.values.map((e) {
    return e.openBox();
  }));

  // Initialize dependency injection
  await di.init();
}
