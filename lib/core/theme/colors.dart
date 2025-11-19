import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF0066CC);
  static const Color primaryLight = Color(0xFF4D94FF);
  static const Color primaryDark = Color(0xFF003D80);

  // Secondary colors
  static const Color secondary = Color(0xFF00BFA5);
  static const Color secondaryLight = Color(0xFF4DF5D4);
  static const Color secondaryDark = Color(0xFF008B7A);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Weather specific colors
  static const Color sunny = Color(0xFFFFB300);
  static const Color cloudy = Color(0xFF90CAF9);
  static const Color rainy = Color(0xFF424242);
  static const Color snowy = Color(0xFFE0F7FA);
  static const Color stormy = Color(0xFF263238);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
  );

  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB0BEC5), Color(0xFF90CAF9)],
  );
}
