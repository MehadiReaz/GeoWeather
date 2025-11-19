# GeoWeather Environment Variables

This file contains environment variables used by the GeoWeather application.

## Setup Instructions

1. **Create a `.env` file** in the project root (same level as `pubspec.yaml`)
2. **Copy contents from `.env.example`**
3. **Replace placeholder values** with your actual API keys
4. **Run code generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Variables

### OPEN_WEATHER_MAP_API_KEY
- **Description**: API key for OpenWeatherMap API
- **Obtain from**: https://openweathermap.org/api
- **Example**: `OPEN_WEATHER_MAP_API_KEY=d6ea4e1d3445b6fb765c6cc6cfecf5b8`

## Important Notes

⚠️ **Security**: 
- Never commit `.env` file to version control
- Add `.env` to `.gitignore`
- The `.env.example` file serves as a template for developers

## Regenerating Generated Code

If you make changes to the environment variables:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Or clean and rebuild:
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```
