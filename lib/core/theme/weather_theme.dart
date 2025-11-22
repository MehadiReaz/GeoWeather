import 'package:flutter/material.dart';

/// Dynamic theme colors based on weather conditions and temperature
class WeatherTheme {
  /// Get gradient colors based on temperature (in Celsius)
  static List<Color> getTemperatureGradient(double temperature, bool isDark) {
    if (temperature >= 35) {
      // Extreme hot (>= 35°C) - Deep orange to red
      return isDark
          ? [const Color(0xFFBF360C), const Color(0xFFD84315)]
          : [const Color(0xFFFF6F00), const Color(0xFFFF3D00)];
    } else if (temperature >= 28) {
      // Hot (28-34°C) - Orange to amber
      return isDark
          ? [const Color(0xFFE65100), const Color(0xFFF57C00)]
          : [const Color(0xFFFF8F00), const Color(0xFFFFB300)];
    } else if (temperature >= 20) {
      // Warm (20-27°C) - Yellow to light orange
      return isDark
          ? [const Color(0xFFF57F17), const Color(0xFFFBC02D)]
          : [const Color(0xFFFFD54F), const Color(0xFFFFB300)];
    } else if (temperature >= 15) {
      // Mild (15-19°C) - Green to teal
      return isDark
          ? [const Color(0xFF00695C), const Color(0xFF00897B)]
          : [const Color(0xFF26A69A), const Color(0xFF4DB6AC)];
    } else if (temperature >= 10) {
      // Cool (10-14°C) - Light blue to blue
      return isDark
          ? [const Color(0xFF1565C0), const Color(0xFF1976D2)]
          : [const Color(0xFF42A5F5), const Color(0xFF64B5F6)];
    } else if (temperature >= 0) {
      // Cold (0-9°C) - Blue to indigo
      return isDark
          ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
          : [const Color(0xFF1E88E5), const Color(0xFF42A5F5)];
    } else {
      // Freezing (< 0°C) - Deep blue to purple
      return isDark
          ? [const Color(0xFF1A237E), const Color(0xFF283593)]
          : [const Color(0xFF3949AB), const Color(0xFF5E35B1)];
    }
  }

  /// Get gradient colors based on weather condition
  static List<Color> getWeatherConditionGradient(
    String condition,
    bool isDark,
  ) {
    final conditionLower = condition.toLowerCase();

    // Clear/Sunny
    if (conditionLower.contains('clear') || conditionLower.contains('sunny')) {
      return isDark
          ? [const Color(0xFFE65100), const Color(0xFFF57C00)]
          : [const Color(0xFFFFB300), const Color(0xFFFF6F00)];
    }

    // Clouds
    if (conditionLower.contains('cloud')) {
      return isDark
          ? [const Color(0xFF455A64), const Color(0xFF607D8B)]
          : [const Color(0xFF78909C), const Color(0xFF90A4AE)];
    }

    // Rain
    if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return isDark
          ? [const Color(0xFF263238), const Color(0xFF37474F)]
          : [const Color(0xFF546E7A), const Color(0xFF78909C)];
    }

    // Thunderstorm
    if (conditionLower.contains('thunder') || conditionLower.contains('storm')) {
      return isDark
          ? [const Color(0xFF1A237E), const Color(0xFF283593)]
          : [const Color(0xFF3949AB), const Color(0xFF5C6BC0)];
    }

    // Snow
    if (conditionLower.contains('snow')) {
      return isDark
          ? [const Color(0xFF37474F), const Color(0xFF546E7A)]
          : [const Color(0xFFB0BEC5), const Color(0xFFCFD8DC)];
    }

    // Mist/Fog/Haze
    if (conditionLower.contains('mist') ||
        conditionLower.contains('fog') ||
        conditionLower.contains('haze')) {
      return isDark
          ? [const Color(0xFF546E7A), const Color(0xFF607D8B)]
          : [const Color(0xFF90A4AE), const Color(0xFFB0BEC5)];
    }

    // Default - Blue gradient
    return isDark
        ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
        : [const Color(0xFF60A5FA), const Color(0xFF3B82F6)];
  }

  /// Get combined gradient based on both temperature and weather condition
  /// Priority: weather condition > temperature
  static List<Color> getDynamicGradient({
    required double temperature,
    required String weatherCondition,
    required bool isDark,
    bool prioritizeCondition = true,
  }) {
    if (prioritizeCondition) {
      // For specific conditions like rain/storm, use condition-based colors
      final conditionLower = weatherCondition.toLowerCase();
      if (conditionLower.contains('rain') ||
          conditionLower.contains('thunder') ||
          conditionLower.contains('storm') ||
          conditionLower.contains('snow') ||
          conditionLower.contains('mist') ||
          conditionLower.contains('fog')) {
        return getWeatherConditionGradient(weatherCondition, isDark);
      }
    }

    // For clear/cloudy or when prioritizing temperature, use temperature-based colors
    return getTemperatureGradient(temperature, isDark);
  }

  /// Get accent color for text and icons based on the gradient
  static Color getAccentColor(List<Color> gradientColors) {
    // Calculate luminance to determine if we need light or dark text
    final avgLuminance = (gradientColors[0].computeLuminance() +
            gradientColors[1].computeLuminance()) /
        2;

    return avgLuminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Get temperature description based on value
  static String getTemperatureDescription(double temperature) {
    if (temperature >= 35) return 'Extremely Hot';
    if (temperature >= 28) return 'Hot';
    if (temperature >= 20) return 'Warm';
    if (temperature >= 15) return 'Mild';
    if (temperature >= 10) return 'Cool';
    if (temperature >= 0) return 'Cold';
    return 'Freezing';
  }

  /// Get emoji representation of temperature
  static String getTemperatureEmoji(double temperature) {
    if (temperature >= 35) return '🔥';
    if (temperature >= 28) return '☀️';
    if (temperature >= 20) return '😊';
    if (temperature >= 15) return '🌤️';
    if (temperature >= 10) return '🧥';
    if (temperature >= 0) return '❄️';
    return '🥶';
  }
}
