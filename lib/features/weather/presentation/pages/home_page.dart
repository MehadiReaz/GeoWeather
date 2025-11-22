import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_weather/core/widgets/custom_app_bar.dart';
import 'package:geo_weather/core/controllers/theme_controller.dart';
import 'package:geo_weather/features/weather/presentation/controllers/weather_controller.dart';
import 'package:geo_weather/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:geo_weather/features/weather/presentation/widgets/temperature_display.dart';
import 'package:geo_weather/features/weather/presentation/widgets/shimmer_loading.dart';

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
/// The page uses GetView which provides easy access
/// to the controller and ensures type safety.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();
    final themeController = Get.find<ThemeController>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? size.width * 0.15 : 20.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'GeoWeather',
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: themeController.toggleTheme,
              tooltip: themeController.isDarkMode ? 'Light Mode' : 'Dark Mode',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const WeatherShimmerLoading();
        }

        if (controller.error.value != null) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_off_rounded,
                      size: 64,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    controller.error.value ?? 'An error occurred',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 32),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: ElevatedButton.icon(
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
                ),
              ],
            ),
          );
        }

        if (controller.weather.value == null) {
          return const Center(child: Text('No weather data available'));
        }

        final weather = controller.weather.value!;
        
        // Trigger animation when weather data is available
        if (_animationController.status == AnimationStatus.dismissed) {
          _animationController.forward();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshWeather();
            _animationController.reset();
            _animationController.forward();
          },
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _AnimatedWeatherCard(
                          delay: const Duration(milliseconds: 100),
                          child: TemperatureDisplay(weather: weather),
                        ),
                        const SizedBox(height: 20),
                        _AnimatedWeatherCard(
                          delay: const Duration(milliseconds: 300),
                          child: WeatherInfoCard(weather: weather),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 20,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Animated wrapper widget for weather cards with staggered delay.
class _AnimatedWeatherCard extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _AnimatedWeatherCard({
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<_AnimatedWeatherCard> createState() => _AnimatedWeatherCardState();
}

class _AnimatedWeatherCardState extends State<_AnimatedWeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Delayed start for staggered effect
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
