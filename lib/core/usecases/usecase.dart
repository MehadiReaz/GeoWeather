import 'package:dartz/dartz.dart';
import 'package:geo_weather/core/errors/failures.dart';

/// Abstract base class for all use cases in the application.
///
/// A UseCase represents a single business action or operation in the domain layer.
/// It encapsulates business logic and coordinates between the presentation layer
/// and the data layer through repositories.
///
/// Benefits of this pattern:
/// - Single Responsibility: Each use case does one thing
/// - Testability: Easy to unit test business logic in isolation
/// - Reusability: Same use case can be called from multiple places
/// - Consistency: Standardized interface across all use cases
///
/// Type Parameters:
/// - [T]: The success return type wrapped in Either
/// - [Params]: The parameters required to execute this use case
///
/// Example usage:
/// ```dart
/// class GetWeatherUseCase extends UseCase<WeatherEntity, WeatherParams> {
///   final WeatherRepository repository;
///
///   GetWeatherUseCase(this.repository);
///
///   @override
///   Future<Either<Failure, WeatherEntity>> call(WeatherParams params) {
///     return repository.getWeather(params.city);
///   }
/// }
/// ```
abstract class UseCase<T, Params> {
  /// Executes this use case with the given parameters.
  ///
  /// Returns Either:
  /// - Left: Contains a Failure if the operation failed
  /// - Right: Contains the success value of type [T]
  Future<Either<Failure, T>> call(Params params);
}

/// Special parameter type for use cases that don't require any parameters.
///
/// This is a marker class following the Null Object pattern to maintain
/// consistency in the UseCase interface even when no parameters are needed.
///
/// Example:
/// ```dart
/// class GetCurrentLocationUseCase extends UseCase<Location, NoParams> {
///   @override
///   Future<Either<Failure, Location>> call(NoParams params) {
///     return locationRepository.getCurrentLocation();
///   }
/// }
/// ```
class NoParams {
  const NoParams();
}
