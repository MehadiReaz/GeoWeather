import 'package:dartz/dartz.dart';
import 'package:geo_weather/core/errors/failures.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';

/// Abstract repository interface defining weather data operations.
///
/// This repository follows the Repository Pattern and acts as an abstraction
/// over data sources. The domain layer depends on this interface, not on
/// concrete implementations.
///
/// Benefits:
/// - Domain layer doesn't know where data comes from (API, cache, etc.)
/// - Easy to swap implementations for testing
/// - Single place to define all weather data operations
/// - Enforces consistent return types (Either<Failure, Data>)
///
/// The actual implementation lives in the data layer and handles:
/// - Network requests to weather APIs
/// - Local caching and offline support
/// - Error handling and retry logic
abstract class WeatherRepository {
  /// Get current weather by coordinates
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  });

  /// Get weather by city name
  Future<Either<Failure, WeatherEntity>> getWeatherByCity({
    required String city,
  });

  /// Get weather by coordinates from cache
  Future<Either<Failure, WeatherEntity>> getCachedWeather({
    required double latitude,
    required double longitude,
  });
}
