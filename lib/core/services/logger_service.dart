import 'package:flutter/foundation.dart';

/// Centralized logging service for the application.
///
/// This service provides a consistent way to log messages throughout the app
/// with different severity levels. In production, this can be extended to send
/// logs to crash reporting services like Firebase Crashlytics or Sentry.
///
/// Benefits:
/// - Centralized logging logic
/// - Easy to enable/disable in production
/// - Can be extended to log to external services
/// - Helps with debugging and monitoring
class LoggerService {
  // Controls whether logging is enabled
  // In production, you might want to disable verbose logs
  static const bool _enableLogging = kDebugMode;

  /// Log informational messages.
  /// Used for general app flow information.
  ///
  /// Example: "User logged in successfully", "Weather data loaded"
  static void info(String message, {String? tag}) {
    if (_enableLogging) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️ INFO: $tagPrefix$message');
    }
  }

  /// Log debug messages.
  /// Used for detailed debugging information during development.
  ///
  /// Example: "API request parameters: {...}", "Cache key: weather_12345"
  static void debug(String message, {String? tag}) {
    if (_enableLogging) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('🐛 DEBUG: $tagPrefix$message');
    }
  }

  /// Log warning messages.
  /// Used for potentially problematic situations that aren't errors.
  ///
  /// Example: "API response time exceeded 5 seconds", "Cache is 90% full"
  static void warning(String message, {String? tag}) {
    if (_enableLogging) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️ WARNING: $tagPrefix$message');
    }
  }

  /// Log error messages.
  /// Used for error conditions that need attention.
  ///
  /// Example: "Failed to fetch weather data", "Location permission denied"
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_enableLogging) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('❌ ERROR: $tagPrefix$message');
      if (error != null) {
        debugPrint('Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    // In production, you could send this to a crash reporting service:
    // FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
  }

  /// Log network-related messages.
  /// Specialized logger for HTTP requests and responses.
  ///
  /// Example: "GET /weather?lat=40.7&lon=-74.0", "Response: 200 OK (234ms)"
  static void network(
    String message, {
    String? method,
    String? url,
    int? statusCode,
  }) {
    if (_enableLogging) {
      final methodPrefix = method != null ? '[$method] ' : '';
      final statusSuffix = statusCode != null ? ' ($statusCode)' : '';
      debugPrint('🌐 NETWORK: $methodPrefix$message$statusSuffix');
      if (url != null) {
        debugPrint('   URL: $url');
      }
    }
  }

  /// Log cache-related operations.
  /// Specialized logger for cache hits, misses, and operations.
  ///
  /// Example: "Cache hit for key: weather_london", "Cache cleared successfully"
  static void cache(String message, {bool? hit}) {
    if (_enableLogging) {
      final hitStatus = hit != null ? (hit ? '✓ HIT' : '✗ MISS') : '';
      debugPrint('💾 CACHE $hitStatus: $message');
    }
  }
}
