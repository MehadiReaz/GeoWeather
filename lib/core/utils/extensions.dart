/// Extension methods for common operations
extension StringExtension on String {
  /// Capitalize the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if the string is a valid email
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if the string is a valid URL
  bool isValidUrl() {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }
}

extension DoubleExtension on double {
  /// Round to a specific number of decimal places
  double roundToDecimalPlaces(int places) {
    final factor = 10.0 * places;
    return (this * factor).round() / factor;
  }

  /// Format as temperature string
  String toTemperatureString() {
    return '${roundToDecimalPlaces(1)}°C';
  }

  /// Check if the value is between min and max
  bool isBetween(double min, double max) {
    return this >= min && this <= max;
  }
}

extension IntExtension on int {
  /// Check if the value is between min and max
  bool isBetween(int min, int max) {
    return this >= min && this <= max;
  }

  /// Format duration in seconds to readable format
  String formatDuration() {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final seconds = this % 60;

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0) parts.add('${seconds}s');

    return parts.isEmpty ? '0s' : parts.join(' ');
  }
}

extension DateTimeExtension on DateTime {
  /// Check if the date is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the date is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if the date is tomorrow
  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get a user-friendly date string
  String toReadableDate() {
    if (isToday()) {
      return 'Today';
    } else if (isYesterday()) {
      return 'Yesterday';
    } else if (isTomorrow()) {
      return 'Tomorrow';
    } else {
      return '$day/$month/$year';
    }
  }

  /// Format time as HH:mm
  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

extension ListExtension<T> on List<T> {
  /// Check if the list is empty and return an empty list if null
  List<T> orEmpty() {
    return this;
  }

  /// Get first element or null if list is empty
  T? getFirstOrNull() {
    return isEmpty ? null : first;
  }

  /// Get last element or null if list is empty
  T? getLastOrNull() {
    return isEmpty ? null : last;
  }

  /// Chunk the list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
