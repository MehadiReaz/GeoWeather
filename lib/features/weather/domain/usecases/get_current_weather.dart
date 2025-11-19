import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:geo_weather/core/errors/failures.dart';
import 'package:geo_weather/core/usecases/usecase.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';
import 'package:geo_weather/features/weather/domain/repositories/weather_repository.dart';

/// Use case for fetching current weather data based on geographic coordinates.
/// 
/// This use case encapsulates the business logic for retrieving weather information
/// for a specific location using latitude and longitude coordinates. It's typically
/// used when the app has already determined the user's current location.
/// 
/// Business Rules:
/// - Requires valid latitude and longitude coordinates
/// - Returns either weather data or a failure
/// - Delegates data fetching to the repository layer
class GetCurrentWeather extends UseCase<WeatherEntity, GetCurrentWeatherParams> {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  /// Executes the use case to get weather data for the given coordinates.
  /// 
  /// Parameters:
  /// - [params]: Contains latitude and longitude coordinates
  /// 
  /// Returns:
  /// - Right(WeatherEntity): Successfully fetched weather data
  /// - Left(Failure): Error occurred (network, cache, etc.)
  @override
  Future<Either<Failure, WeatherEntity>> call(GetCurrentWeatherParams params) {
    return repository.getCurrentWeatherByCoordinates(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

/// Parameters required for the GetCurrentWeather use case.
/// 
/// Using Equatable for value equality, which is useful for:
/// - Testing: Easy to compare parameter objects
/// - Caching: Can be used as cache keys
/// - State management: Helps with change detection
class GetCurrentWeatherParams extends Equatable {
  final double latitude;
  final double longitude;

  const GetCurrentWeatherParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

