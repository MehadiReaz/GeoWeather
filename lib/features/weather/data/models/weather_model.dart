import 'package:geo_weather/core/errors/exceptions.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';

/// Data layer model for weather information with JSON serialization.
/// 
/// This class extends WeatherEntity and adds serialization capabilities
/// for converting between JSON (from API) and Dart objects.
/// 
/// Responsibilities:
/// - Parse JSON from OpenWeatherMap API responses
/// - Serialize weather data back to JSON for caching
/// - Handle null values and provide sensible defaults
/// - Transform API data format to match our domain entity
/// 
/// The model pattern keeps serialization logic out of the domain layer,
/// maintaining clean architecture separation.
/// 
/// Inherits Equatable from WeatherEntity for value-based equality.
class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.id,
    required super.city,
    required super.country,
    required super.latitude,
    required super.longitude,
    required super.temperature,
    required super.feelsLike,
    required super.minTemperature,
    required super.maxTemperature,
    required super.humidity,
    required super.pressure,
    required super.windSpeed,
    required super.description,
    required super.main,
    required super.icon,
    required super.cloudiness,
    required super.visibility,
    required super.sunrise,
    required super.sunset,
    required super.dateTime,
  });

  /// Factory constructor to create WeatherModel from JSON with validation.
  /// 
  /// This method parses JSON from OpenWeatherMap API and handles:
  /// - Missing or null fields with sensible defaults
  /// - Type conversions (int to double, etc.)
  /// - Nested data structure navigation
  /// - Invalid data with validation
  /// 
  /// Throws [InvalidDataException] if critical fields are missing or invalid.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    try {
      // Validate critical fields exist
      if (!json.containsKey('id') || !json.containsKey('name')) {
        throw InvalidDataException(
          message: 'Missing required weather data fields',
        );
      }

      // Safely extract nested weather array
      final weatherArray = json['weather'] as List<dynamic>?;
      if (weatherArray == null || weatherArray.isEmpty) {
        throw InvalidDataException(
          message: 'Weather array is missing or empty',
        );
      }

      final weather = weatherArray[0] as Map<String, dynamic>;
      final main = json['main'] as Map<String, dynamic>?;
      final coord = json['coord'] as Map<String, dynamic>?;
      final wind = json['wind'] as Map<String, dynamic>?;
      final clouds = json['clouds'] as Map<String, dynamic>?;
      final sys = json['sys'] as Map<String, dynamic>?;

      // Validate essential nested objects exist
      if (main == null || coord == null) {
        throw InvalidDataException(
          message: 'Missing essential weather data sections',
        );
      }

      return WeatherModel(
        id: json['id'] as int,
        city: json['name'] as String? ?? 'Unknown',
        country: sys?['country'] as String? ?? '',
        
        // Coordinates with safe conversion
        latitude: _toDouble(coord['lat']),
        longitude: _toDouble(coord['lon']),
        
        // Temperature data with safe conversion
        temperature: _toDouble(main['temp']),
        feelsLike: _toDouble(main['feels_like']),
        minTemperature: _toDouble(main['temp_min']),
        maxTemperature: _toDouble(main['temp_max']),
        
        // Atmospheric conditions with safe conversion
        humidity: _toInt(main['humidity']),
        pressure: _toInt(main['pressure']),
        windSpeed: _toDouble(wind?['speed']),
        
        // Weather description
        description: weather['description'] as String? ?? '',
        main: weather['main'] as String? ?? '',
        icon: weather['icon'] as String? ?? '01d',
        
        // Additional data
        cloudiness: _toInt(clouds?['all']),
        visibility: _toInt(json['visibility']),
        sunrise: _toInt(sys?['sunrise']),
        sunset: _toInt(sys?['sunset']),
        
        // Timestamp - validate it's not too far in the past/future
        dateTime: _parseDateTime(json['dt']),
      );
    } on InvalidDataException {
      rethrow;
    } catch (e) {
      throw InvalidDataException(
        message: 'Failed to parse weather data: ${e.toString()}',
      );
    }
  }

  /// Safely converts a value to double, providing a default if null or invalid.
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Safely converts a value to int, providing a default if null or invalid.
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Parses a Unix timestamp to DateTime with validation.
  /// 
  /// Validates the timestamp is reasonable (not too far in past/future)
  /// to catch obviously invalid data.
  static DateTime _parseDateTime(dynamic value) {
    final timestamp = _toInt(value);
    
    // Validate timestamp is reasonable (after year 2000, before year 2100)
    if (timestamp < 946684800 || timestamp > 4102444800) {
      return DateTime.now(); // Fallback to current time
    }
    
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  /// Convert WeatherModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': city,
      'coord': {
        'lat': latitude,
        'lon': longitude,
      },
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': minTemperature,
        'temp_max': maxTemperature,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {
        'speed': windSpeed,
      },
      'weather': [
        {
          'description': description,
          'main': main,
          'icon': icon,
        }
      ],
      'clouds': {
        'all': cloudiness,
      },
      'visibility': visibility,
      'sys': {
        'country': country,
        'sunrise': sunrise,
        'sunset': sunset,
      },
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
