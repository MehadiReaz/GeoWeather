import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_weather/app/routes/app_pages.dart';
import 'package:geo_weather/app/routes/app_routes.dart';
import 'package:geo_weather/core/theme/app_theme.dart';
import 'package:geo_weather/injection/injection_container.dart';

/// Entry point of the GeoWeather application.
/// Initializes all required services before launching the app.
void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up dependency injection container with all core services
  // This includes network, storage, location services, and API configuration
  await setupServiceLocator();
  
  // Launch the application
  runApp(const GeoWeatherApp());
}

/// Root widget of the GeoWeather application.
/// Configures Material Design theming, navigation routes, and global app settings.
class GeoWeatherApp extends StatelessWidget {
  const GeoWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GeoWeather',
      
      // Theme configuration supporting both light and dark modes
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system, // Follows system preference
      
      // Navigation configuration
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      
      // UI preferences
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.native, // Native platform transitions
    );
  }
}
