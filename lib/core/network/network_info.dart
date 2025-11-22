import 'package:connectivity_plus/connectivity_plus.dart';

/// Service interface for checking device network connectivity.
///
/// This simple service determines whether the device has an active
/// internet connection, which is crucial for deciding whether to:
/// - Fetch data from remote APIs
/// - Fall back to cached data
/// - Show offline UI states
///
/// The abstraction allows for easy testing and mocking.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo using connectivity_plus package.
///
/// Checks the device's network connectivity state to determine
/// if the app can make network requests.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  /// Checks if the device has an active internet connection.
  ///
  /// Returns true if connected via WiFi, mobile data, or ethernet.
  /// Returns false if no connection is available.
  ///
  /// Note: This checks connection state, not actual internet access.
  /// A device might be connected to WiFi but have no internet access.
  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
