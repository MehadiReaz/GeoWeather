import 'package:equatable/equatable.dart';

/// Core domain entity representing weather information for a location.
/// 
/// This entity is part of the domain layer and represents the business model
/// of weather data. It's framework-independent and contains only business logic.
/// 
/// Entity vs Model:
/// - Entity: Domain layer (this class) - business rules and logic
/// - Model: Data layer - includes JSON serialization, API mapping
/// 
/// This separation ensures the business logic isn't tied to data sources.
/// 
/// Uses Equatable for value-based equality, enabling:
/// - Easy comparison of weather objects by their values
/// - Better state management (detects actual data changes)
/// - Simplified testing (straightforward assertions)
/// - Efficient UI updates (rebuilds only when data changes)
class WeatherEntity extends Equatable {
  // Location identifiers
  final int id;                  // Unique city/location ID from weather API
  final String city;             // City name (e.g., "London", "New York")
  final String country;          // Country code (e.g., "GB", "US")
  final double latitude;         // Geographic latitude
  final double longitude;        // Geographic longitude
  
  // Temperature data (in Celsius by default)
  final double temperature;      // Current temperature
  final double feelsLike;        // Perceived temperature (considering wind, humidity)
  final double minTemperature;   // Minimum temperature expected
  final double maxTemperature;   // Maximum temperature expected
  
  // Atmospheric conditions
  final int humidity;            // Humidity percentage (0-100%)
  final int pressure;            // Atmospheric pressure (hPa)
  final double windSpeed;        // Wind speed (m/s)
  
  // Weather description
  final String description;      // Detailed description (e.g., "light rain")
  final String main;             // Main weather condition (e.g., "Rain", "Clear")
  final String icon;             // Weather icon code for visual representation
  
  // Additional meteorological data
  final int cloudiness;          // Cloudiness percentage (0-100%)
  final int visibility;          // Visibility distance (meters)
  final int sunrise;             // Sunrise time (Unix timestamp)
  final int sunset;              // Sunset time (Unix timestamp)
  final DateTime dateTime;       // When this weather data was recorded

  const WeatherEntity({
    required this.id,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.main,
    required this.icon,
    required this.cloudiness,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
  });

  /// Equatable props for value-based equality comparison.
  /// 
  /// Two WeatherEntity objects are considered equal if all their
  /// properties have the same values, regardless of being different instances.
  /// 
  /// This enables:
  /// - weatherEntity1 == weatherEntity2 (compares values, not references)
  /// - Efficient change detection in state management
  /// - Proper Set/Map operations using entities as keys
  @override
  List<Object?> get props => [
        id,
        city,
        country,
        latitude,
        longitude,
        temperature,
        feelsLike,
        minTemperature,
        maxTemperature,
        humidity,
        pressure,
        windSpeed,
        description,
        main,
        icon,
        cloudiness,
        visibility,
        sunrise,
        sunset,
        dateTime,
      ];

  /// Optional: Override toString for better debugging
  /// 
  /// When you print a WeatherEntity, you'll see meaningful information
  /// instead of just "Instance of 'WeatherEntity'"
  @override
  bool? get stringify => true;
}
