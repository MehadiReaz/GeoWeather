/// Centralized route constants for app navigation.
/// 
/// Keeping route names as constants prevents typos and makes
/// navigation more maintainable. If a route changes, we only
/// need to update it in one place.
/// 
/// Usage:
/// ```dart
/// Get.toNamed(AppRoutes.settings);
/// ```
class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String splash = '/splash';
}
