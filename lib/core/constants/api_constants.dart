/// API-related constants for the application
class ApiConstants {
  // Base URL and endpoints
  static const String baseUrl = 'https://api.openweathermap.org';
  static const String weatherEndpoint = '/data/2.5/weather';
  static const String forecastEndpoint = '/data/2.5/forecast';
  static const String geocodingEndpoint = '/geo/1.0/direct';

  // Query parameters
  static const String units = 'metric'; // Celsius
  static const String lang = 'en';

  // HTTP timeouts (in seconds)
  static const int connectTimeout = 10;
  static const int receiveTimeout = 10;

  // Error messages
  static const String networkError = 'Network error occurred';
  static const String timeoutError = 'Request timeout';
  static const String invalidApiKey = 'Invalid API key';
}
