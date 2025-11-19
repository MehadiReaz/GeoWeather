import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:geo_weather/core/errors/failures.dart';
import 'package:geo_weather/core/usecases/usecase.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';
import 'package:geo_weather/features/weather/domain/repositories/weather_repository.dart';

/// Use case for fetching weather data for a specific city by name.
/// 
/// This use case is used when users want to search for weather in a specific city
/// or when the app needs to display weather for saved locations.
/// 
/// Business Rules:
/// - Requires a non-empty city name
/// - Returns either weather data or a failure
/// - City name should be validated before reaching this layer
class GetWeatherForCity extends UseCase<WeatherEntity, GetWeatherForCityParams> {
  final WeatherRepository repository;

  GetWeatherForCity(this.repository);

  /// Executes the use case to get weather data for the specified city.
  /// 
  /// Parameters:
  /// - [params]: Contains the city name to search for
  /// 
  /// Returns:
  /// - Right(WeatherEntity): Successfully fetched weather data
  /// - Left(Failure): Error occurred (network, city not found, etc.)
  @override
  Future<Either<Failure, WeatherEntity>> call(GetWeatherForCityParams params) {
    return repository.getWeatherByCity(city: params.city);
  }
}

/// Parameters required for the GetWeatherForCity use case.
/// 
/// Encapsulates the city name parameter in a type-safe manner.
class GetWeatherForCityParams extends Equatable {
  final String city;

  const GetWeatherForCityParams({required this.city});

  @override
  List<Object?> get props => [city];
}

