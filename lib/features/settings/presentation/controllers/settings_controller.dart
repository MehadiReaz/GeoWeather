import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_weather/core/services/storage_service.dart';
import 'package:geo_weather/core/services/logger_service.dart';

/// Controller managing app settings and user preferences.
///
/// This controller handles:
/// - Theme mode (light/dark)
/// - Temperature units (Celsius/Fahrenheit/Kelvin)
/// - Language preferences
/// - Persistent storage of all settings
///
/// Settings are automatically saved to local storage and loaded on app startup.
class SettingsController extends GetxController {
  final StorageService storageService;

  // Storage keys for persisting settings
  static const String _darkModeKey = 'settings_dark_mode';
  static const String _temperatureUnitKey = 'settings_temperature_unit';
  static const String _languageKey = 'settings_language';

  // Reactive observables for settings state
  final isDarkMode = false.obs;
  final temperatureUnit = 'Celsius'.obs;
  final language = 'English'.obs;

  SettingsController({required this.storageService});

  /// Called when controller is first initialized.
  /// Loads saved settings from local storage.
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Loads all saved settings from local storage.
  ///
  /// If no saved settings exist, defaults are used:
  /// - Dark mode: false (light theme)
  /// - Temperature: Celsius
  /// - Language: English
  Future<void> _loadSettings() async {
    try {
      // Load dark mode preference
      final savedDarkMode = await storageService.getBool(_darkModeKey);
      if (savedDarkMode != null) {
        isDarkMode.value = savedDarkMode;
        _applyTheme(savedDarkMode);
      }

      // Load temperature unit preference
      final savedTempUnit = await storageService.getString(_temperatureUnitKey);
      if (savedTempUnit != null) {
        temperatureUnit.value = savedTempUnit;
      }

      // Load language preference
      final savedLanguage = await storageService.getString(_languageKey);
      if (savedLanguage != null) {
        language.value = savedLanguage;
      }

      LoggerService.info(
        'Settings loaded successfully',
        tag: 'SettingsController',
      );
    } catch (e) {
      LoggerService.error(
        'Failed to load settings',
        tag: 'SettingsController',
        error: e,
      );
    }
  }

  /// Toggles between light and dark theme modes.
  ///
  /// The theme change is immediately applied to the app and saved to storage.
  Future<void> toggleDarkMode(bool value) async {
    try {
      isDarkMode.value = value;
      await storageService.saveBool(_darkModeKey, value);
      _applyTheme(value);

      LoggerService.info(
        'Theme changed to ${value ? "dark" : "light"} mode',
        tag: 'SettingsController',
      );
    } catch (e) {
      LoggerService.error(
        'Failed to toggle dark mode',
        tag: 'SettingsController',
        error: e,
      );
    }
  }

  /// Applies the theme to the app using GetX's theme management.
  void _applyTheme(bool isDark) {
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Changes the temperature unit preference.
  ///
  /// Supported units:
  /// - Celsius (°C)
  /// - Fahrenheit (°F)
  /// - Kelvin (K)
  ///
  /// Note: This changes the display preference only. The actual temperature
  /// conversion logic should be implemented in the presentation layer.
  Future<void> changeTemperatureUnit(String unit) async {
    try {
      temperatureUnit.value = unit;
      await storageService.saveString(_temperatureUnitKey, unit);

      LoggerService.info(
        'Temperature unit changed to $unit',
        tag: 'SettingsController',
      );
    } catch (e) {
      LoggerService.error(
        'Failed to change temperature unit',
        tag: 'SettingsController',
        error: e,
      );
    }
  }

  /// Changes the app language preference.
  ///
  /// Supported languages:
  /// - English
  /// - Spanish
  /// - French
  /// - German
  /// (Add more as needed)
  ///
  /// Note: Actual localization needs to be implemented using GetX's
  /// internationalization or other i18n packages.
  Future<void> changeLanguage(String lang) async {
    try {
      language.value = lang;
      await storageService.saveString(_languageKey, lang);

      LoggerService.info(
        'Language changed to $lang',
        tag: 'SettingsController',
      );

      // TODO: Implement actual language change using GetX translations
      // Get.updateLocale(Locale(languageCode));
    } catch (e) {
      LoggerService.error(
        'Failed to change language',
        tag: 'SettingsController',
        error: e,
      );
    }
  }

  /// Resets all settings to their default values.
  ///
  /// This clears all stored preferences and resets to:
  /// - Light theme
  /// - Celsius temperature
  /// - English language
  Future<void> resetToDefaults() async {
    try {
      await storageService.remove(_darkModeKey);
      await storageService.remove(_temperatureUnitKey);
      await storageService.remove(_languageKey);

      isDarkMode.value = false;
      temperatureUnit.value = 'Celsius';
      language.value = 'English';

      _applyTheme(false);

      LoggerService.info(
        'Settings reset to defaults',
        tag: 'SettingsController',
      );

      Get.snackbar(
        'Settings Reset',
        'All settings have been reset to default values',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      LoggerService.error(
        'Failed to reset settings',
        tag: 'SettingsController',
        error: e,
      );
    }
  }
}
