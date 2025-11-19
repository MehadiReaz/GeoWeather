import 'package:mockito/mockito.dart';
import 'package:geo_weather/core/network/network_info.dart';
import 'package:geo_weather/core/services/storage_service.dart';
import 'package:geo_weather/core/services/location_service.dart';
import 'package:geo_weather/features/weather/domain/repositories/weather_repository.dart';

/// Mock helper classes for testing
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockStorageService extends Mock implements StorageService {}

class MockLocationService extends Mock implements LocationService {}

class MockWeatherRepository extends Mock implements WeatherRepository {}
