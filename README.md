# GeoWeather

A clean, modular Flutter weather application that displays real-time weather conditions using the OpenWeatherMap API. The app features automatic location detection, local caching, and a modern UI built with GetX for state management.

## Features

- 🌍 **Auto-Location Detection** - Automatically detects your location
- 🌤️ **Real-time Weather** - Fetches current weather from OpenWeatherMap API
- 💾 **Local Caching** - Caches weather data for offline access
- 🎨 **Material Design** - Modern, clean UI with light and dark themes
- 🔒 **Secure API Keys** - Uses `envied` package for secure environment variable management
- 📦 **Modular Architecture** - Clean architecture with separation of concerns
- ⚡ **GetX State Management** - Efficient state management and dependency injection

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   ├── routes/
│   │   ├── app_pages.dart       # Navigation pages/routes
│   │   └── app_routes.dart      # Route constants
│   └── bindings/
│       └── initial_bindings.dart # App-wide bindings
├── core/
│   ├── constants/               # App and API constants
│   ├── errors/                  # Failures and exceptions
│   ├── network/                 # Dio client and network info
│   ├── services/                # Storage and location services
│   ├── theme/                   # Colors, text styles, theme
│   ├── utils/                   # Extensions and helpers
│   └── widgets/                 # Reusable UI components
├── features/
│   ├── weather/                 # Weather feature
│   │   ├── data/                # Datasources, models, repositories
│   │   ├── domain/              # Entities, repositories, usecases
│   │   └── presentation/        # Controllers, pages, widgets, bindings
│   └── settings/                # Settings feature
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection/
│   └── injection_container.dart # Dependency injection setup
└── env/
    ├── env.dart                 # Environment variables (envied)
    └── ENV_SETUP.md            # Environment setup guide
```

## Architecture

This project follows **Clean Architecture** principles with layered separation:

- **Presentation Layer**: UI components, pages, and controllers (GetX)
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Repositories, datasources, and models

## Technologies & Packages

- **Flutter**: UI framework
- **GetX**: State management and dependency injection
- **Dio**: HTTP client for API requests
- **Envied**: Secure environment variable management
- **Connectivity Plus**: Network connectivity checking
- **Shared Preferences**: Local data persistence
- **Geolocator**: Device location services
- **Dartz**: Functional programming (Either/Option)

## Setup Instructions

### Prerequisites
- Flutter 3.10+
- Dart 3.10+
- OpenWeatherMap API Key ([Get it here](https://openweathermap.org/api))

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd geo_weather
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment variables**
   - Copy `.env.example` to `.env` in the project root
   - Add your OpenWeatherMap API key:
     ```
     OPEN_WEATHER_MAP_API_KEY=your_api_key_here
     ```

4. **Generate environment file**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Environment Configuration

This project uses the `envied` package for secure API key management:

1. **Create `.env` file** in project root (same level as `pubspec.yaml`)
2. **Add your API key**:
   ```
   OPEN_WEATHER_MAP_API_KEY=d6ea4e1d3445b6fb765c6cc6cfecf5b8
   ```
3. **Generate code**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Important Security Notes
- ⚠️ Never commit `.env` file to version control
- ✅ Add `.env` to `.gitignore` (already done)
- ✅ `.env.example` serves as a template for developers

## Usage

### Get Current Weather by Location
```dart
final weatherController = Get.find<WeatherController>();
await weatherController.fetchWeatherForCurrentLocation();
```

### Get Weather by City
```dart
await weatherController.fetchWeatherForCity('London');
```

### Refresh Weather Data
```dart
await weatherController.refreshWeather();
```

## Available Routes

- `/` - Home page (weather display)
- `/settings` - Settings page

## Testing

Run tests with:
```bash
flutter test
```

Mock helpers are available in `test/test_utils/mock_helpers.dart`

## Project Features

### Weather Display
- Current temperature and "feels like" temperature
- Weather condition and description
- Min/Max temperatures
- Humidity, wind speed, pressure
- Visibility and cloudiness
- Last updated time

### Settings Page
- Dark mode toggle
- Temperature unit selection (Celsius/Fahrenheit)
- Language preferences

### Smart Features
- **Offline Support**: Caches weather data locally
- **Network Aware**: Checks connectivity before API calls
- **Auto-Refresh**: Pull-to-refresh functionality
- **Error Handling**: Comprehensive error states and messages

## Regenerating Code

If you modify environment variables or need to regenerate code:

```bash
# Clean previous builds
dart run build_runner clean

# Generate new code
dart run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

### Missing `env.g.dart` file
```bash
dart run build_runner build --delete-conflicting-outputs
```

### API Key not recognized
- Verify `.env` file exists in project root
- Check API key format in `.env` file
- Regenerate code with build_runner

### Location permission issues
- Ensure location permissions are granted on device
- Check `AndroidManifest.xml` (Android) or `Info.plist` (iOS)

## Future Enhancements

- [ ] Weather forecast (5-day, 15-day)
- [ ] Multiple saved locations
- [ ] Weather alerts
- [ ] Weather maps and radar
- [ ] Localization support
- [ ] Advanced analytics

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://github.com/jonataslaw/getx/wiki)
- [OpenWeatherMap API](https://openweathermap.org/api)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Envied Package](https://pub.dev/packages/envied)

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
