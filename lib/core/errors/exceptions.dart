/// Custom exceptions for the application
abstract class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({super.message = 'Network error occurred'});
}

class TimeoutException extends AppException {
  TimeoutException({super.message = 'Request timeout'});
}

class CacheException extends AppException {
  CacheException({super.message = 'Cache error occurred'});
}

class ApiException extends AppException {
  final int? statusCode;

  ApiException({super.message = 'API error occurred', this.statusCode});
}

class InvalidDataException extends AppException {
  InvalidDataException({super.message = 'Invalid data received'});
}

class LocationException extends AppException {
  LocationException({super.message = 'Location error occurred'});
}

class InvalidParameterException extends AppException {
  InvalidParameterException({super.message = 'Invalid parameter provided'});
}
