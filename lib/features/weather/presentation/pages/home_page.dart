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
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'GeoWeather',
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refreshWeather,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Fetching weather...');
        }

        if (controller.error.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_off_rounded,
                      size: 64,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    controller.error.value ?? 'An error occurred',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: controller.fetchWeatherForCurrentLocation,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.weather.value == null) {
          return const Center(child: Text('No weather data available'));
        }

        final weather = controller.weather.value!;

        return RefreshIndicator(
          onRefresh: controller.refreshWeather,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top + 60,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TemperatureDisplay(weather: weather),
                    const SizedBox(height: 20),
                    WeatherInfoCard(weather: weather),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
