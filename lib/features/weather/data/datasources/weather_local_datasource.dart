import 'package:geo_weather/core/services/storage_service.dart';
import 'package:geo_weather/core/services/logger_service.dart';
import 'package:geo_weather/features/weather/data/models/weather_model.dart';
import 'dart:convert';

/// Interface for local weather data caching operations.
///
/// This datasource handles persistence of weather data to local storage,
/// enabling offline functionality and faster app startup.
///
/// Caching Strategy:
/// - Cache weather data after successful API calls
/// - Use location/city as cache keys
/// - Store as JSON strings for easy serialization
/// - Track cache timestamps for expiration
/// - Provide methods to retrieve and clear cache
///
/// Cache Expiration:
/// - Weather data is considered fresh for 30 minutes
/// - Stale data can still be returned for offline scenarios
/// - Expired data is automatically cleaned up
abstract class WeatherLocalDatasource {
  /// Cache weather data locally with current timestamp
  Future<void> cacheWeather(WeatherModel weatherModel);

  /// Get cached weather data if not expired
  ///
  /// Returns null if:
  /// - No cache exists for the key
  /// - Cache is expired (older than expiration duration)
  Future<WeatherModel?> getCachedWeather(String key);

  /// Get cached weather data regardless of expiration
  ///
  /// Useful for offline scenarios where stale data is better than no data
  Future<WeatherModel?> getCachedWeatherStale(String key);

  /// Check if cached data exists and is not expired
  Future<bool> isCacheValid(String key);

  /// Clear all cached weather data
  Future<void> clearCache();

  /// Clear specific cached entry
  Future<void> clearCacheFor(String key);
}

/// Implementation of local weather caching using SharedPreferences.
class WeatherLocalDatasourceImpl implements WeatherLocalDatasource {
  final StorageService storageService;

  // Prefix for all weather cache keys to avoid conflicts with other stored data
  static const String _weatherCacheKey = 'cached_weather_';
  static const String _timestampSuffix = '_timestamp';

  // Cache expiration duration: 30 minutes
  // After this time, cached data is considered stale
  static const Duration cacheExpiration = Duration(minutes: 30);

  WeatherLocalDatasourceImpl(this.storageService);

  @override
  Future<void> cacheWeather(WeatherModel weatherModel) async {
    try {
      final cacheKey = '$_weatherCacheKey${weatherModel.id}';
      final timestampKey = '$cacheKey$_timestampSuffix';

      // Serialize weather model to JSON string
      final jsonString = jsonEncode(weatherModel.toJson());

      // Store weather data and current timestamp
      await storageService.saveString(cacheKey, jsonString);
      await storageService.saveInt(
        timestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      LoggerService.cache('Weather cached for ID: ${weatherModel.id}');
    } catch (e) {
      LoggerService.error(
        'Failed to cache weather',
        tag: 'WeatherLocalDatasource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<WeatherModel?> getCachedWeather(String key) async {
    try {
      // Check if cache is valid (exists and not expired)
      if (!await isCacheValid(key)) {
        LoggerService.cache('Cache miss or expired for key: $key', hit: false);
        return null;
      }

      return await _getCachedWeatherData(key);
    } catch (e) {
      LoggerService.error(
        'Failed to get cached weather',
        tag: 'WeatherLocalDatasource',
        error: e,
      );
      return null;
    }
  }

  @override
  Future<WeatherModel?> getCachedWeatherStale(String key) async {
    try {
      return await _getCachedWeatherData(key);
    } catch (e) {
      LoggerService.error(
        'Failed to get stale cached weather',
        tag: 'WeatherLocalDatasource',
        error: e,
      );
      return null;
    }
  }

  /// Internal method to retrieve cached weather data without expiration check
  Future<WeatherModel?> _getCachedWeatherData(String key) async {
    final cacheKey = '$_weatherCacheKey$key';
    final jsonString = await storageService.getString(cacheKey);

    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = WeatherModel.fromJson(json);
      LoggerService.cache('Cache hit for key: $key', hit: true);
      return model;
    }

    return null;
  }

  @override
  Future<bool> isCacheValid(String key) async {
    try {
      final cacheKey = '$_weatherCacheKey$key';
      final timestampKey = '$cacheKey$_timestampSuffix';

      // Check if cache data exists
      final jsonString = await storageService.getString(cacheKey);
      if (jsonString == null) {
        return false;
      }

      // Check if timestamp exists
      final timestamp = await storageService.getInt(timestampKey);
      if (timestamp == null) {
        // Old cache without timestamp - consider invalid
        return false;
      }

      // Check if cache is not expired
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final age = now.difference(cacheTime);

      final isValid = age < cacheExpiration;

      if (!isValid) {
        LoggerService.cache(
          'Cache expired for key: $key (age: ${age.inMinutes} minutes)',
        );
      }

      return isValid;
    } catch (e) {
      LoggerService.error(
        'Failed to check cache validity',
        tag: 'WeatherLocalDatasource',
        error: e,
      );
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await storageService.clear();
      LoggerService.cache('All cache cleared');
    } catch (e) {
      LoggerService.error(
        'Failed to clear cache',
        tag: 'WeatherLocalDatasource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> clearCacheFor(String key) async {
    try {
      final cacheKey = '$_weatherCacheKey$key';
      final timestampKey = '$cacheKey$_timestampSuffix';

      await storageService.remove(cacheKey);
      await storageService.remove(timestampKey);

      LoggerService.cache('Cache cleared for key: $key');
    } catch (e) {
      LoggerService.error(
        'Failed to clear cache for key',
        tag: 'WeatherLocalDatasource',
        error: e,
      );
      rethrow;
    }
  }
}
