import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import '../core/flavors/flavor_name_key.dart';
import '../core/flavors/flavor_type_extension.dart';
import 'app.dart';
import 'datasources/hive_info.dart';
import 'di/depedency_injection.dart' as di;

Future<void> main() async {
  // Initialize app
  await init();

  runApp(const App());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // firebase init
  await Firebase.initializeApp();

  // flavor config
  FlavorConfig(
    name: "PRODUCTION",
    variables: {
      FlavorNameKey.type: FlavorType.production,
    },
  );

  // hive
  await HiveInfo.init();

  // Initialize dependency injection
  await di.init();
}
