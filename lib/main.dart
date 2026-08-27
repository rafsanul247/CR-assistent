import 'injection.dart' as injection;
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/push/fcm_service.dart';
import 'core/storage/storage_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeStorage();
  await injection.init();

  // Initialize Firebase + request permission + print the FCM token.
  // Errors here are non-fatal so a missing Firebase config doesn't block
  // local development.
  try {
    await injection.sl<FcmService>().init();
  } catch (e, st) {
    debugPrint('FCM init failed: $e\n$st');
  }

  runApp(const MyApp());
}
