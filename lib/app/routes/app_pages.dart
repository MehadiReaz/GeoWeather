import 'package:get/get.dart';
import 'package:geo_weather/app/routes/app_routes.dart';
import 'package:geo_weather/features/weather/presentation/pages/home_page.dart';
import 'package:geo_weather/features/weather/presentation/bindings/weather_binding.dart';
import 'package:geo_weather/features/settings/presentation/pages/settings_page.dart';
import 'package:geo_weather/features/settings/presentation/bindings/settings_binding.dart';

/// Centralized route configuration for the entire application.
///
/// This class defines all navigation routes and their associated:
/// - Page widgets
/// - Dependency injection bindings
/// - Transition animations
///
/// Benefits:
/// - Single source of truth for app navigation
/// - Automatic dependency injection per route
/// - Easy to add middleware (auth checks, etc.)
/// - Type-safe navigation with route constants
abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: WeatherBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.leftToRight,
    ),
  ];
}
