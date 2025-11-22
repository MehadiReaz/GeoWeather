import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo_weather/core/services/location_service.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';
import 'package:geo_weather/features/weather/domain/usecases/get_current_weather.dart';
import 'package:geo_weather/features/weather/domain/usecases/get_weather_for_city.dart';

/// Controller managing the weather feature's state and business logic.
///
/// This controller follows the GetX pattern for state management and acts as
/// the bridge between the UI and the domain layer (use cases).
///
/// Responsibilities:
/// - Managing loading, error, and data states
/// - Coordinating weather data fetching via use cases
/// - Handling location services for current location weather
/// - Providing refresh functionality
/// - Exposing reactive state to the UI layer
///
/// The controller doesn't contain business logic - that lives in use cases.
/// It only orchestrates the flow and manages presentation state.
class WeatherController extends GetxController {
  final GetCurrentWeather getCurrentWeather;
  final GetWeatherForCity getWeatherForCity;
  final LocationService locationService;

  // Reactive state observables for the UI to listen to
  final isLoading = false.obs;
  final weather = Rx<WeatherEntity?>(null);
  final error = Rx<String?>(null);

  // Location monitoring
  StreamSubscription<LocationData>? _locationSubscription;
  LocationData? _lastLocation;
  static const double _minDistanceForUpdate = 1000; // 1km in meters

  WeatherController({
    required this.getCurrentWeather,
    required this.getWeatherForCity,
    required this.locationService,
  });

  /// Called when the controller is first initialized.
  /// Automatically fetches weather for the user's current location
  /// and starts monitoring location changes.
  @override
  void onInit() {
    super.onInit();
    fetchWeatherForCurrentLocation();
    _startLocationMonitoring();
  }

  /// Called when the controller is disposed.
  /// Cleans up the location monitoring subscription.
  @override
  void onClose() {
    _locationSubscription?.cancel();
    super.onClose();
  }

  /// Starts monitoring location changes and updates weather
  /// when the user moves significantly (more than 1km).
  void _startLocationMonitoring() async {
    try {
      _locationSubscription = locationService.getLocationStream().listen(
        (location) {
          _handleLocationUpdate(location);
        },
        onError: (error) {
          // Silent fail for location monitoring errors
          // User can still manually refresh
        },
      );
    } catch (e) {
      // Silent fail - location monitoring is a background feature
    }
  }

  /// Handles new location updates and fetches weather if moved significantly.
  void _handleLocationUpdate(LocationData newLocation) async {
    // Skip if loading or if we don't have a previous location
    if (isLoading.value || _lastLocation == null) {
      _lastLocation = newLocation;
      return;
    }

    // Calculate distance from last location
    final distance = Geolocator.distanceBetween(
      _lastLocation!.latitude,
      _lastLocation!.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );

    // Only update if moved more than the threshold
    if (distance >= _minDistanceForUpdate) {
      _lastLocation = newLocation;
      await _fetchWeatherForLocation(newLocation);
    }
  }

  /// Internal method to fetch weather for a specific location.
  Future<void> _fetchWeatherForLocation(LocationData location) async {
    try {
      isLoading.value = true;
      error.value = null;

      final result = await getCurrentWeather(
        GetCurrentWeatherParams(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );

      result.fold(
        (failure) => error.value = failure.message,
        (weatherEntity) => weather.value = weatherEntity,
      );
    } catch (e) {
      error.value = 'Failed to fetch weather: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches weather data for the device's current GPS location.
  ///
  /// Flow:
  /// 1. Gets the device's current location from location service
  /// 2. Calls the GetCurrentWeather use case with coordinates
  /// 3. Updates state based on success or failure
  ///
  /// Handles:
  /// - Location permission errors
  /// - Network errors
  /// - API errors
  /// - Cache fallback when offline
  Future<void> fetchWeatherForCurrentLocation() async {
    try {
      isLoading.value = true;
      error.value = null;

      // Get device's current GPS coordinates
      final location = await locationService.getCurrentLocation();
      _lastLocation = location; // Store for comparison

      // Fetch weather for this location
      await _fetchWeatherForLocation(location);
    } catch (e) {
      // Catch unexpected errors (e.g., location service errors)
      error.value = 'Failed to get location: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Fetches weather data for a specific city by name.
  ///
  /// This is used when users search for weather in a different location.
  ///
  /// Parameters:
  /// - [city]: The name of the city to search for
  ///
  /// Note: Basic validation should be done in the UI before calling this.
  Future<void> fetchWeatherForCity(String city) async {
    try {
      isLoading.value = true;
      error.value = null;

      // Call the use case with proper parameters
      final result = await getWeatherForCity(
        GetWeatherForCityParams(city: city),
      );

      // Handle the Either<Failure, WeatherEntity> result
      result.fold(
        (failure) => error.value = failure.message,
        (weatherEntity) => weather.value = weatherEntity,
      );
    } catch (e) {
      // Catch unexpected errors
      error.value = 'Failed to fetch weather: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes the current weather data.
  ///
  /// If weather data is already loaded, it refreshes data for the same city.
  /// Otherwise, it fetches weather for the current location.
  ///
  /// This is typically called by pull-to-refresh gestures.
  Future<void> refreshWeather() async {
    if (weather.value != null) {
      // Refresh data for the currently displayed city
      await fetchWeatherForCity(weather.value!.city);
    } else {
      // No previous data, fetch for current location
      await fetchWeatherForCurrentLocation();
    }
  }
}
