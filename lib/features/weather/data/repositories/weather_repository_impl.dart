import 'package:dartz/dartz.dart';
import 'package:geo_weather/core/errors/exceptions.dart';
import 'package:geo_weather/core/errors/failures.dart';
import 'package:geo_weather/core/network/network_info.dart';
import 'package:geo_weather/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:geo_weather/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';
import 'package:geo_weather/features/weather/domain/repositories/weather_repository.dart';

/// Implementation of WeatherRepository following the Repository Pattern.
/// 
/// This class acts as the single source of truth for weather data in the application.
/// It coordinates between remote and local data sources, handling:
/// - Network availability checking
/// - Remote API calls when online
/// - Local cache fallback when offline
/// - Automatic caching of fresh data
/// - Proper error handling and conversion to domain failures
/// 
/// The repository shields the domain layer from data source implementation details.
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource remoteDatasource;
  final WeatherLocalDatasource localDatasource;
  final NetworkInfo networkInfo;
  final String apiKey;

  WeatherRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
    required this.apiKey,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    // Check if device has internet connectivity
    if (await networkInfo.isConnected) {
      try {
        // Attempt to fetch fresh data from the API
        final remoteWeather = await remoteDatasource.getCurrentWeatherByCoordinates(
          latitude: latitude,
          longitude: longitude,
          apiKey: apiKey,
        );
        
        // Cache the fresh data for offline use
        await localDatasource.cacheWeather(remoteWeather);
        
        return Right(remoteWeather);
      } on NetworkException catch (e) {
        // Network-related errors (connectivity issues, timeouts)
        return Left(NetworkFailure(message: e.message));
      } on TimeoutException catch (e) {
        // Specific timeout handling
        return Left(TimeoutFailure(message: e.message));
      } on ApiException catch (e) {
        // API-specific errors (4xx, 5xx responses)
        return Left(ApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on InvalidDataException catch (e) {
        // Data parsing or validation errors
        return Left(InvalidDataFailure(message: e.message));
      } catch (e) {
        // Catch any unexpected errors
        return Left(GenericFailure(message: 'Failed to fetch weather: ${e.toString()}'));
      }
    } else {
      // Device is offline - try to get cached data
      try {
        final cachedWeather = await localDatasource.getCachedWeather(
          '${latitude}_$longitude',
        );
        
        if (cachedWeather != null) {
          return Right(cachedWeather);
        }
        
        // No cached data available
        return Left(NetworkFailure(
          message: 'No internet connection and no cached data available',
        ));
      } on CacheException catch (e) {
        // Cache-specific errors
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        // Unexpected cache-related errors
        return Left(CacheFailure(message: 'Failed to retrieve cached weather: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherByCity({
    required String city,
  }) async {
    // Check if device has internet connectivity
    if (await networkInfo.isConnected) {
      try {
        // Attempt to fetch fresh data from the API
        final remoteWeather = await remoteDatasource.getWeatherByCity(
          city: city,
          apiKey: apiKey,
        );
        
        // Cache the fresh data for offline use
        await localDatasource.cacheWeather(remoteWeather);
        
        return Right(remoteWeather);
      } on NetworkException catch (e) {
        // Network-related errors (connectivity issues, timeouts)
        return Left(NetworkFailure(message: e.message));
      } on TimeoutException catch (e) {
        // Specific timeout handling
        return Left(TimeoutFailure(message: e.message));
      } on ApiException catch (e) {
        // API-specific errors (4xx, 5xx responses, invalid API key)
        return Left(ApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on InvalidDataException catch (e) {
        // Data parsing or validation errors
        return Left(InvalidDataFailure(message: e.message));
      } catch (e) {
        // Catch any unexpected errors
        return Left(GenericFailure(message: 'Failed to fetch weather: ${e.toString()}'));
      }
    } else {
      // Device is offline - try to get cached data
      try {
        final cachedWeather = await localDatasource.getCachedWeather(city);
        
        if (cachedWeather != null) {
          return Right(cachedWeather);
        }
        
        // No cached data available
        return Left(NetworkFailure(
          message: 'No internet connection and no cached data available',
        ));
      } on CacheException catch (e) {
        // Cache-specific errors
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        // Unexpected cache-related errors
        return Left(CacheFailure(message: 'Failed to retrieve cached weather: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCachedWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Attempt to retrieve cached weather data
      final cachedWeather = await localDatasource.getCachedWeather(
        '${latitude}_$longitude',
      );
      
      if (cachedWeather != null) {
        return Right(cachedWeather);
      }
      
      // No cached data found for this location
      return Left(CacheFailure(message: 'No cached weather found for this location'));
    } on CacheException catch (e) {
      // Cache-specific errors
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      // Unexpected errors
      return Left(CacheFailure(message: 'Failed to retrieve cached weather: ${e.toString()}'));
    }
  }
}
