import 'package:geo_weather/core/network/dio_client.dart';
import 'package:geo_weather/core/constants/api_constants.dart';
import 'package:geo_weather/features/weather/data/models/weather_model.dart';

/// Interface for fetching weather data from remote API sources.
///
/// This datasource is responsible for all external API calls related to weather.
/// It's part of the data layer and should only be accessed by repositories.
///
/// Responsibilities:
/// - Make HTTP requests to OpenWeatherMap API
/// - Transform raw API responses into WeatherModel objects
/// - Throw appropriate exceptions for error cases
///
/// Does NOT handle:
/// - Caching (that's the repository's job)
/// - Business logic (that's the domain layer's job)
/// - Error-to-failure conversion (repository handles that)
abstract class WeatherRemoteDatasource {
  /// Fetch current weather by coordinates from API
  Future<WeatherModel> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
    required String apiKey,
  });

  /// Fetch weather by city name from API
  Future<WeatherModel> getWeatherByCity({
    required String city,
    required String apiKey,
  });
}

/// Concrete implementation of WeatherRemoteDatasource using OpenWeatherMap API.
///
/// This implementation uses our DioClient to make HTTP requests and handles
/// the specifics of the OpenWeatherMap API format.
class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  final DioClient dioClient;

  WeatherRemoteDatasourceImpl(this.dioClient);

  @override
  Future<WeatherModel> getCurrentWeatherByCoordinates({
    required double latitude,
    required double longitude,
    required String apiKey,
  }) async {
    final response = await dioClient.get(
      ApiConstants.weatherEndpoint,
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': apiKey,
        'units': ApiConstants.units,
        'lang': ApiConstants.lang,
      },
    );

    return WeatherModel.fromJson(response.data);
  }

  @override
  Future<WeatherModel> getWeatherByCity({
    required String city,
    required String apiKey,
  }) async {
    final response = await dioClient.get(
      ApiConstants.weatherEndpoint,
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': ApiConstants.units,
        'lang': ApiConstants.lang,
      },
    );

    return WeatherModel.fromJson(response.data);
  }
}
