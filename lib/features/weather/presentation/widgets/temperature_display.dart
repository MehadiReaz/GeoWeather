import 'package:flutter/material.dart';
import 'package:geo_weather/core/theme/colors.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';
import 'package:geo_weather/features/weather/presentation/widgets/weather_icon.dart';

/// Widget for displaying temperature information
class TemperatureDisplay extends StatelessWidget {
  final WeatherEntity weather;

  const TemperatureDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Responsive sizing
    final iconSize = isTablet ? 180.0 : 140.0;
    final tempFontSize = isTablet ? 96.0 : 72.0;
    final padding = isTablet ? 36.0 : 28.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
              : [const Color(0xFF60A5FA), const Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: isTablet ? 24 : 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      weather.city,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 24 : null,
                          ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                weather.description.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? 16 : null,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isTablet ? 24 : 20),
              // Weather Icon from OpenWeatherMap API
              WeatherIcon(iconCode: weather.icon, size: iconSize),
              SizedBox(height: isTablet ? 24 : 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.temperature.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: tempFontSize,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                  Text(
                    '°C',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300,
                      fontSize: isTablet ? 28 : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Feels like ${weather.feelsLike.toStringAsFixed(0)}°C',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: isTablet ? 18 : null,
                ),
              ),
              SizedBox(height: isTablet ? 32 : 28),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 28 : 20,
                  vertical: isTablet ? 20 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TemperatureRange(
                      label: 'High',
                      temperature: weather.maxTemperature,
                      icon: Icons.arrow_upward_rounded,
                      isTablet: isTablet,
                    ),
                    Container(
                      width: 1,
                      height: isTablet ? 50 : 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _TemperatureRange(
                      label: 'Low',
                      temperature: weather.minTemperature,
                      icon: Icons.arrow_downward_rounded,
                      isTablet: isTablet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemperatureRange extends StatelessWidget {
  final String label;
  final double temperature;
  final IconData icon;
  final bool isTablet;

  const _TemperatureRange({
    required this.label,
    required this.temperature,
    required this.icon,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: isTablet ? 20 : 16,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withOpacity(0.85),
            fontSize: isTablet ? 14 : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${temperature.toStringAsFixed(0)}°',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 20 : null,
          ),
        ),
      ],
    );
  }
}
