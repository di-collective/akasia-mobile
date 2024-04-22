import 'app.dart';
import 'di/di.dart' as di;
import 'package:flutter/material.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  di.configureDependencies();

  runApp(const App());
}
