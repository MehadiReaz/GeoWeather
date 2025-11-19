import 'package:geolocator/geolocator.dart';
import 'package:geo_weather/core/errors/exceptions.dart';

/// Simple data class holding geographic location information.
/// 
/// Contains the essential location data needed by the app.
/// Using a custom class instead of the Geolocator's Position class
/// keeps our code independent of the specific location package.
class LocationData {
  final double latitude;      // Geographic latitude (-90 to 90)
  final double longitude;     // Geographic longitude (-180 to 180)
  final double accuracy;      // Location accuracy in meters
  final DateTime timestamp;   // When this location was determined

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });
}

/// Service interface for accessing device location capabilities.
/// 
/// This service abstracts the geolocator package and provides a clean
/// interface for location operations. It handles:
/// - Checking if location services are enabled
/// - Managing location permissions
/// - Getting current device coordinates
/// 
/// By abstracting the location package, we can easily:
/// - Mock location services in tests
/// - Switch to a different location package if needed
/// - Add caching or location filtering logic
abstract class LocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<LocationData> getCurrentLocation();
}

/// Implementation of LocationService using Geolocator
class LocationServiceImpl implements LocationService {
  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw LocationException(message: 'Failed to check location service: $e');
    }
  }

  @override
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      throw LocationException(message: 'Failed to check permission: $e');
    }
  }

  @override
  Future<LocationPermission> requestPermission() async {
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      throw LocationException(message: 'Failed to request permission: $e');
    }
  }

  @override
  Future<LocationData> getCurrentLocation() async {
    try {
      final isServiceEnabled = await isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw LocationException(
          message: 'Location service is disabled',
        );
      }

      var permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(message: 'Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          message: 'Location permission is permanently denied',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          position.timestamp.millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      throw LocationException(message: 'Failed to get current location: $e');
    }
  }
}
