import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_weather/core/services/storage_service.dart';

/// Controller for managing app theme (light/dark mode)
class ThemeController extends GetxController {
  final StorageService _storageService;

  // Observable for theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // Key for storing theme preference
  static const String _themeModeKey = 'theme_mode';

  ThemeController(this._storageService);

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load saved theme mode from storage
  Future<void> _loadThemeMode() async {
    final savedTheme = await _storageService.getString(_themeModeKey);
    if (savedTheme != null) {
      _themeMode.value = _themeModeFromString(savedTheme);
      Get.changeThemeMode(_themeMode.value);
    }
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }

    Get.changeThemeMode(_themeMode.value);
    _saveThemeMode();
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(_themeMode.value);
    _saveThemeMode();
  }

  /// Save theme mode to storage
  Future<void> _saveThemeMode() async {
    await _storageService.saveString(
      _themeModeKey,
      _themeMode.value.toString(),
    );
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }
}
