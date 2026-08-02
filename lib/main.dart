import 'injection.dart' as injection;
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/storage/storage_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeStorage();
  await injection.init();
  runApp(const MyApp());
}
