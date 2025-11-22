import 'package:flutter/material.dart';
import 'package:geo_weather/core/theme/colors.dart';
import 'package:geo_weather/features/weather/domain/entities/weather_entity.dart';

/// Widget for displaying detailed weather information
class WeatherInfoCard extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherInfoCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid columns
    int crossAxisCount = 2;
    if (screenWidth > 900) {
      crossAxisCount = 3;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth > 600 ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Details',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: screenWidth > 600 ? 24 : 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * 12) /
                    crossAxisCount;
                final itemHeight = itemWidth / 1.3;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: _WeatherDetailBox(
                        label: 'Humidity',
                        value: '${weather.humidity}%',
                        icon: Icons.water_drop_rounded,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: _WeatherDetailBox(
                        label: 'Wind Speed',
                        value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                        icon: Icons.air_rounded,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: _WeatherDetailBox(
                        label: 'Pressure',
                        value: '${weather.pressure} hPa',
                        icon: Icons.speed_rounded,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: _WeatherDetailBox(
                        label: 'Visibility',
                        value:
                            '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                        icon: Icons.visibility_rounded,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: _WeatherDetailBox(
                        label: 'Cloudiness',
                        value: '${weather.cloudiness}%',
                        icon: Icons.cloud_rounded,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: _WeatherDetailBox(
                        label: 'Condition',
                        value: weather.main,
                        icon: Icons.wb_sunny_rounded,
                        isDark: isDark,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetailBox extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _WeatherDetailBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  State<_WeatherDetailBox> createState() => _WeatherDetailBoxState();
}

class _WeatherDetailBoxState extends State<_WeatherDetailBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.primary, size: 24),
              const SizedBox(height: 6),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.value,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
