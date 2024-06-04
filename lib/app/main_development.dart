import 'package:akasia365mc/core/flavors/flavor_name_key.dart';
import 'package:akasia365mc/core/flavors/flavor_type_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

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

  // Initialize dependency injection
  await di.init();
}
