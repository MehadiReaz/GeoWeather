import 'dart:math';
import 'package:geo_weather/core/errors/failures.dart';

/// Utility helper functions
class AppHelpers {
  /// Convert a failure to a readable error message
  static String failureToString(Failure failure) {
    return failure.message;
  }

  /// Generate a unique timestamp-based ID
  static String generateUniqueId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Validate latitude value
  static bool isValidLatitude(double latitude) {
    return latitude >= -90 && latitude <= 90;
  }

  /// Validate longitude value
  static bool isValidLongitude(double longitude) {
    return longitude >= -180 && longitude <= 180;
  }

  /// Calculate distance between two coordinates (in km) using Haversine formula
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Format bytes to readable size
  static String formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var fileSize = bytes.toDouble();
    var suffixIndex = 0;

    while (fileSize > 1024 && suffixIndex < suffixes.length - 1) {
      fileSize /= 1024;
      suffixIndex++;
    }

    return '${fileSize.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }

  /// Check if a string contains only numbers
  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  /// Remove all non-numeric characters from string
  static String removeNonNumeric(String str) {
    return str.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String str) {
    return str
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
