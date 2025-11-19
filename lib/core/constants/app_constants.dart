/// App-wide constants
class AppConstants {
  // App info
  static const String appName = 'GeoWeather';
  static const String appVersion = '1.0.0';

  // Cache duration
  static const Duration cacheDuration = Duration(minutes: 10);

  // Pagination
  static const int pageSize = 20;

  // Default values
  static const String defaultLanguage = 'en';
  static const String defaultTemperatureUnit = '°C';

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // String constants
  static const String noDataMessage = 'No data available';
  static const String tryAgainMessage = 'Please try again';
  static const String loadingMessage = 'Loading...';
  static const String errorMessage = 'An error occurred';
}
