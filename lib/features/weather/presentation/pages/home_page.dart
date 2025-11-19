import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_weather/core/widgets/custom_app_bar.dart';
import 'package:geo_weather/core/widgets/loading_widget.dart';
import 'package:geo_weather/features/weather/presentation/controllers/weather_controller.dart';
import 'package:geo_weather/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:geo_weather/features/weather/presentation/widgets/temperature_display.dart';

/// Main home page displaying current weather information.
/// 
/// This page is the entry point of the app and shows weather data
/// for the user's current location or a searched city.
/// 
/// Features:
/// - Automatic weather fetching on load
/// - Pull-to-refresh functionality
/// - Loading states while fetching data
/// - Error states with retry button
/// - Reactive UI that updates when weather data changes
/// 
/// The page uses GetView<WeatherController> which provides easy access
/// to the controller and ensures type safety.
class HomePage extends GetView<WeatherController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'GeoWeather',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshWeather,
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const LoadingWidget(message: 'Fetching weather...');
          }

          if (controller.error.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    controller.error.value ?? 'An error occurred',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchWeatherForCurrentLocation,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.weather.value == null) {
            return const Center(
              child: Text('No weather data available'),
            );
          }

          final weather = controller.weather.value!;

          return RefreshIndicator(
            onRefresh: controller.refreshWeather,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TemperatureDisplay(weather: weather),
                const SizedBox(height: 24),
                WeatherInfoCard(weather: weather),
              ],
            ),
          );
        },
      ),
    );
  }
}
