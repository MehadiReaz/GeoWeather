/// Abstract failure class and concrete failure types for the application
abstract class Failure {
  final String message;

  Failure({required this.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({super.message = 'Network error occurred'});
}

class CacheFailure extends Failure {
  CacheFailure({super.message = 'Cache error occurred'});
}

class ApiFailure extends Failure {
  final int? statusCode;

  ApiFailure({super.message = 'API error occurred', this.statusCode});
}

class InvalidDataFailure extends Failure {
  InvalidDataFailure({super.message = 'Invalid data received'});
}

class LocationFailure extends Failure {
  LocationFailure({super.message = 'Location error occurred'});
}

class TimeoutFailure extends Failure {
  TimeoutFailure({super.message = 'Request timeout'});
}

class GenericFailure extends Failure {
  GenericFailure({super.message = 'An error occurred'});
}
