import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_weather/core/widgets/custom_app_bar.dart';
import 'package:geo_weather/features/settings/presentation/controllers/settings_controller.dart';

/// Settings page
class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Display',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: controller.isDarkMode.value,
                      onChanged: controller.toggleDarkMode,
                    ),
                  ),
                  const Divider(),
                  Obx(
                    () => ListTile(
                      title: const Text('Temperature Unit'),
                      subtitle: Text(controller.temperatureUnit.value),
                      onTap: () => _showTemperatureDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'General',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => ListTile(
                      title: const Text('Language'),
                      subtitle: Text(controller.language.value),
                      onTap: () => _showLanguageDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTemperatureDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Temperature Unit',
      content: Obx(
        () => Column(
          children: [
            RadioListTile(
              title: const Text('Celsius'),
              value: 'Celsius',
              groupValue: controller.temperatureUnit.value,
              onChanged: (value) {
                controller.changeTemperatureUnit(value ?? 'Celsius');
                Get.back();
              },
            ),
            RadioListTile(
              title: const Text('Fahrenheit'),
              value: 'Fahrenheit',
              groupValue: controller.temperatureUnit.value,
              onChanged: (value) {
                controller.changeTemperatureUnit(value ?? 'Celsius');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Language',
      content: Obx(
        () => Column(
          children: [
            RadioListTile(
              title: const Text('English'),
              value: 'English',
              groupValue: controller.language.value,
              onChanged: (value) {
                controller.changeLanguage(value ?? 'English');
                Get.back();
              },
            ),
            RadioListTile(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: controller.language.value,
              onChanged: (value) {
                controller.changeLanguage(value ?? 'English');
                Get.back();
              },
            ),
            RadioListTile(
              title: const Text('French'),
              value: 'French',
              groupValue: controller.language.value,
              onChanged: (value) {
                controller.changeLanguage(value ?? 'English');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
