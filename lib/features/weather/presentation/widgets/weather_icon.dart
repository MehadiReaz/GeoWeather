import 'package:flutter/material.dart';

/// Widget for displaying the weather icon from OpenWeatherMap API.
/// 
/// OpenWeatherMap provides icons that represent current weather conditions.
/// Icon codes (e.g., '01d', '10n') are returned from the API and used to
/// fetch the corresponding weather icon image.
/// 
/// Icon URL format: https://openweathermap.org/img/wn/{icon_code}@2x.png
/// 
/// Examples of icon codes:
/// - 01d: clear sky (day)
/// - 01n: clear sky (night)
/// - 02d: few clouds (day)
/// - 09d: shower rain
/// - 10d: rain (day)
/// - 11d: thunderstorm
/// - 13d: snow
/// - 50d: mist
class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({
    super.key,
    required this.iconCode,
    this.size = 100.0,
  });

  /// Generates the full URL for the weather icon
  String get iconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';

  @override
  Widget build(BuildContext context) {
    return Image.network(
      iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // Show loading indicator while fetching icon
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      // Show error icon if image fails to load
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.cloud_off,
          size: size,
          color: Colors.grey,
        );
      },
    );
  }
}
