import 'package:shared_preferences/shared_preferences.dart';
import 'package:geo_weather/core/errors/exceptions.dart';

/// Service interface for local data persistence operations.
///
/// This service wraps SharedPreferences and provides a clean interface
/// for storing and retrieving data locally on the device.
///
/// Use cases:
/// - Caching API responses for offline access
/// - Storing user preferences (theme, units, language)
/// - Persisting app state between sessions
///
/// Benefits of this abstraction:
/// - Easy to mock in tests
/// - Can add encryption layer if needed
/// - Can switch to different storage (Hive, SQLite) without changing app code
/// - Consistent error handling
abstract class StorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> saveDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

/// Implementation of StorageService using SharedPreferences
class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  StorageServiceImpl(this._prefs);

  @override
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string: $e');
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string: $e');
    }
  }

  @override
  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save int: $e');
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get int: $e');
    }
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save bool: $e');
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get bool: $e');
    }
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save double: $e');
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get double: $e');
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear storage: $e');
    }
  }
}
