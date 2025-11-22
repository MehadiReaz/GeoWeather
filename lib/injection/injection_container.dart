import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geo_weather/core/network/dio_client.dart';
import 'package:geo_weather/core/network/network_info.dart';
import 'package:geo_weather/core/services/storage_service.dart';
import 'package:geo_weather/core/services/location_service.dart';
import 'package:geo_weather/core/controllers/theme_controller.dart';
import 'package:geo_weather/env/env.dart';

/// Sets up the dependency injection container for the entire application.
///
/// This function initializes all core services and external dependencies
/// that will be available throughout the app lifecycle using GetX dependency injection.
///
/// Initialization order matters:
/// 1. External packages (Dio, Connectivity, SharedPreferences)
/// 2. Core services that depend on external packages
/// 3. Environment configuration
///
/// This should be called once during app startup in main() before runApp().
Future<void> setupServiceLocator() async {
  // === External Package Dependencies ===
  // These are third-party packages that form the foundation for our services

  // HTTP client for making API requests
  Get.put(Dio());

  // Network connectivity checker to determine online/offline status
  Get.put(Connectivity());

  // Local storage for caching and preferences
  // This is async so we await it before proceeding
  final prefs = await SharedPreferences.getInstance();
  Get.put(prefs);

  // === Core Service Layer ===
  // Our custom services that wrap and extend external packages

  // Network connectivity information service
  Get.put<NetworkInfo>(NetworkInfoImpl(Get.find()));

  // Centralized HTTP client with error handling and configuration
  Get.put<DioClient>(DioClient(Get.find()));

  // Storage service for local data persistence
  Get.put<StorageService>(StorageServiceImpl(Get.find()));

  // Location service for getting device GPS coordinates
  Get.put<LocationService>(LocationServiceImpl());

  // === Controllers ===
  // Theme controller for managing app theme
  Get.put<ThemeController>(ThemeController(Get.find()), permanent: true);

  // === Environment Configuration ===
  // Secure API key loaded from environment variables via envied
  // Tagged for specific injection when needed
  Get.put<String>(Env.apiKey, tag: 'apiKey');
}
