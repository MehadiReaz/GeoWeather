import 'package:get/get.dart';
import 'package:geo_weather/features/settings/presentation/controllers/settings_controller.dart';

/// Dependency injection binding for the settings feature.
///
/// Sets up the settings controller with its required dependencies
/// when navigating to settings-related pages.
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Inject SettingsController with StorageService dependency
    Get.put(SettingsController(storageService: Get.find()));
  }
}
