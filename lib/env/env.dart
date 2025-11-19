import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment variables configuration using envied
/// To use this:
/// 1. Create a .env file in the project root (same level as pubspec.yaml)
/// 2. Add your API keys: OPEN_WEATHER_MAP_API_KEY=your_key_here
/// 3. Run: dart run build_runner build --delete-conflicting-outputs
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPEN_WEATHER_MAP_API_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}
