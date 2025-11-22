import 'package:get/get.dart';
import 'package:geo_weather/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:geo_weather/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:geo_weather/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:geo_weather/features/weather/domain/repositories/weather_repository.dart';
import 'package:geo_weather/features/weather/domain/usecases/get_current_weather.dart';
import 'package:geo_weather/features/weather/domain/usecases/get_weather_for_city.dart';
import 'package:geo_weather/features/weather/presentation/controllers/weather_controller.dart';

/// Dependency injection binding for the weather feature.
///
/// This binding sets up all dependencies needed for the weather feature
/// when navigating to weather-related pages. It follows GetX's lazy
/// instantiation pattern.
///
/// Dependency hierarchy (bottom-up):
/// 1. Datasources (local & remote)
/// 2. Repository (uses datasources)
/// 3. Use cases (use repository)
/// 4. Controller (uses use cases)
///
/// Using lazyPut means these dependencies are only created when first accessed,
/// improving app performance. The controller uses Get.put to ensure it's
/// immediately available.
class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    // Datasources
    Get.lazyPut<WeatherRemoteDatasource>(
      () => WeatherRemoteDatasourceImpl(Get.find()),
    );
    Get.lazyPut<WeatherLocalDatasource>(
      () => WeatherLocalDatasourceImpl(Get.find()),
    );

    // Repository
    Get.lazyPut<WeatherRepository>(
      () => WeatherRepositoryImpl(
        remoteDatasource: Get.find(),
        localDatasource: Get.find(),
        networkInfo: Get.find(),
        apiKey: Get.find<String>(tag: 'apiKey'), // API key from environment
      ),
    );

    // Use cases
    Get.lazyPut(() => GetCurrentWeather(Get.find()));
    Get.lazyPut(() => GetWeatherForCity(Get.find()));

    // Controller
    Get.put(
      WeatherController(
        getCurrentWeather: Get.find(),
        getWeatherForCity: Get.find(),
        locationService: Get.find(),
      ),
    );
  }
}
