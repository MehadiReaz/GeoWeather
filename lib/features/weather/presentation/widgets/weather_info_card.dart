import 'package:flutter/material.dart';
import 'package:geo_weather/core/theme/colors.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';

/// Widget for displaying detailed weather information
class WeatherInfoCard extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherInfoCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _WeatherDetail(
              label: 'Condition',
              value: weather.main,
              icon: Icons.cloud,
            ),
            _WeatherDetail(
              label: 'Humidity',
              value: '${weather.humidity}%',
              icon: Icons.opacity,
            ),
            _WeatherDetail(
              label: 'Wind Speed',
              value: '${weather.windSpeed} m/s',
              icon: Icons.air,
            ),
            _WeatherDetail(
              label: 'Pressure',
              value: '${weather.pressure} hPa',
              icon: Icons.compress,
            ),
            _WeatherDetail(
              label: 'Visibility',
              value: '${weather.visibility / 1000} km',
              icon: Icons.visibility,
            ),
            _WeatherDetail(
              label: 'Cloudiness',
              value: '${weather.cloudiness}%',
              icon: Icons.cloud_queue,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherDetail({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
