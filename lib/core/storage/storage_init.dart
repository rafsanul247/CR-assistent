import 'storage_service.dart';

/// Initialize Hive storage
Future<void> initializeStorage() async {
  await StorageService.init();
}
