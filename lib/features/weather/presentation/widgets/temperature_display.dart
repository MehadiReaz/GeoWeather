import 'package:flutter/material.dart';
import 'package:geo_weather/core/theme/colors.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';

/// Widget for displaying temperature information
class TemperatureDisplay extends StatelessWidget {
  final WeatherEntity weather;

  const TemperatureDisplay({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.sunnyGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              weather.city,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weather.description.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 56,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Feels like ${weather.feelsLike.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TemperatureRange(
                  label: 'High',
                  temperature: weather.maxTemperature,
                ),
                _TemperatureRange(
                  label: 'Low',
                  temperature: weather.minTemperature,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TemperatureRange extends StatelessWidget {
  final String label;
  final double temperature;

  const _TemperatureRange({
    required this.label,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${temperature.toStringAsFixed(1)}°C',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
