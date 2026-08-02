import 'package:hive_flutter/hive_flutter.dart';

/// Hive storage service
/// Provides key-value storage functionality
class StorageService {
  static Box? _box;

  /// Initialize storage
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('app_storage');
  }

  /// Get value by key
  static T? get<T>(String key) {
    return _box?.get(key) as T?;
  }

  /// Set value by key
  static Future<void> set(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  /// Delete value by key
  static Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  /// Clear all data
  static Future<void> clear() async {
    await _box?.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return _box?.containsKey(key) ?? false;
  }

  /// Get all keys
  static List<String> getAllKeys() {
    return _box?.keys.cast<String>().toList() ?? [];
  }

  /// Close storage
  static Future<void> close() async {
    await _box?.close();
  }
}
