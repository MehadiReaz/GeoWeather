# GeoWeather Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Clean Architecture Principles](#clean-architecture-principles)
3. [Layer Structure](#layer-structure)
4. [Data Flow](#data-flow)
5. [Dependency Injection](#dependency-injection)
6. [State Management](#state-management)
7. [Error Handling](#error-handling)
8. [Caching Strategy](#caching-strategy)
9. [Testing Strategy](#testing-strategy)
10. [Best Practices](#best-practices)

## Overview

GeoWeather follows **Clean Architecture** principles combined with **GetX** for state management. The architecture separates concerns into distinct layers, making the codebase maintainable, testable, and scalable.

### Key Benefits
- ✅ **Separation of Concerns**: Each layer has a single responsibility
- ✅ **Testability**: Business logic is independent of frameworks
- ✅ **Flexibility**: Easy to swap implementations (e.g., change state management or API)
- ✅ **Scalability**: Adding new features follows established patterns
- ✅ **Maintainability**: Clear structure makes code easy to understand and modify

## Clean Architecture Principles

The app is organized into three main layers, with dependencies flowing inward:

```
┌─────────────────────────────────────────────────────┐
│         Presentation Layer (UI)                      │
│  • Pages, Widgets, Controllers                       │
│  • GetX for state management                         │
└──────────────────┬──────────────────────────────────┘
                   │ depends on ↓
┌──────────────────▼──────────────────────────────────┐
│         Domain Layer (Business Logic)                │
│  • Entities, Use Cases, Repository Interfaces        │
│  • Pure Dart, framework-independent                  │
└──────────────────┬──────────────────────────────────┘
                   │ depends on ↓
┌──────────────────▼──────────────────────────────────┐
│         Data Layer (Data Sources)                    │
│  • Models, Repository Implementations, Datasources   │
│  • API calls, local storage, external services       │
└─────────────────────────────────────────────────────┘
```

### Dependency Rule
**Dependencies point inward**: Outer layers can depend on inner layers, but inner layers never depend on outer layers.

- Presentation depends on Domain
- Domain depends on nothing (pure business logic)
- Data depends on Domain (implements interfaces)

## Layer Structure

### 1. Presentation Layer (`lib/features/*/presentation/`)

**Responsibility**: Handle UI rendering and user interactions.

**Components**:
- **Pages**: Full-screen views (e.g., `HomePage`, `SettingsPage`)
- **Widgets**: Reusable UI components (e.g., `WeatherCard`, `TemperatureDisplay`)
- **Controllers**: State management and UI logic using GetX
- **Bindings**: Dependency injection for feature-specific dependencies

**Example**:
```dart
// Controller manages state and coordinates with use cases
class WeatherController extends GetxController {
  final GetCurrentWeather getCurrentWeather;
  final weather = Rx<WeatherEntity?>(null);
  
  Future<void> fetchWeather() async {
    final result = await getCurrentWeather(...);
    result.fold(
      (failure) => showError(failure.message),
      (data) => weather.value = data,
    );
  }
}
```

**Key Principles**:
- Controllers don't contain business logic
- UI components are reactive (Obx, GetX)
- Controllers coordinate between UI and domain layer

### 2. Domain Layer (`lib/features/*/domain/`)

**Responsibility**: Contain pure business logic, independent of frameworks.

**Components**:
- **Entities**: Core business models (e.g., `WeatherEntity`)
- **Repositories**: Interfaces defining data operations
- **Use Cases**: Single-purpose business operations

**Example**:
```dart
// Entity: Pure data model
class WeatherEntity {
  final String city;
  final double temperature;
  // No serialization, no framework dependencies
}

// Repository Interface: Defines what data operations are needed
abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather(String city);
}

// Use Case: Single business operation
class GetCurrentWeather extends UseCase<WeatherEntity, Params> {
  final WeatherRepository repository;
  
  @override
  Future<Either<Failure, WeatherEntity>> call(Params params) {
    return repository.getCurrentWeather(params.lat, params.lon);
  }
}
```

**Key Principles**:
- No Flutter/GetX dependencies in domain layer
- Entities are immutable
- Use cases encapsulate single business operations
- Repositories are interfaces (implemented in data layer)

### 3. Data Layer (`lib/features/*/data/`)

**Responsibility**: Fetch and persist data from various sources.

**Components**:
- **Models**: Data transfer objects with JSON serialization
- **Repositories**: Concrete implementations of domain repositories
- **Datasources**: Abstract data fetching (remote API, local cache)

**Example**:
```dart
// Model: Extends entity, adds serialization
class WeatherModel extends WeatherEntity {
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Parse API response
  }
  
  Map<String, dynamic> toJson() {
    // Serialize for caching
  }
}

// Repository Implementation: Coordinates datasources
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource remote;
  final WeatherLocalDatasource local;
  final NetworkInfo networkInfo;
  
  @override
  Future<Either<Failure, WeatherEntity>> getWeather(...) async {
    if (await networkInfo.isConnected) {
      // Fetch from API, cache the result
      final data = await remote.getWeather(...);
      await local.cacheWeather(data);
      return Right(data);
    } else {
      // Return cached data
      final cached = await local.getCachedWeather(...);
      return cached != null 
        ? Right(cached)
        : Left(NetworkFailure());
    }
  }
}
```

**Key Principles**:
- Models handle serialization/deserialization
- Repositories coordinate between remote and local datasources
- Datasources are single-responsibility (remote XOR local)
- Error handling converts exceptions to Failures

## Data Flow

### Typical Request Flow

1. **User Interaction** → UI triggers controller method
2. **Controller** → Calls use case with parameters
3. **Use Case** → Executes business logic, calls repository
4. **Repository** → Checks network, fetches from appropriate datasource
5. **Datasource** → Makes API call or reads from cache
6. **Model** → Parses API response to entity
7. **Repository** → Returns `Either<Failure, Entity>`
8. **Use Case** → Passes result back to controller
9. **Controller** → Updates reactive state
10. **UI** → Automatically re-renders with new state

### Example Flow Diagram

```
┌─────────────┐
│  HomePage   │ User pulls to refresh
└──────┬──────┘
       ↓
┌─────────────────────┐
│ WeatherController   │ fetchWeather()
└──────┬──────────────┘
       ↓
┌─────────────────────┐
│ GetCurrentWeather   │ call(params)
└──────┬──────────────┘
       ↓
┌─────────────────────┐
│ WeatherRepository   │ getCurrentWeather(lat, lon)
└──────┬──────────────┘
       ↓
   [Network Check]
       ↓
┌─────────────────────┐     ┌──────────────────┐
│  RemoteDatasource   │ OR  │ LocalDatasource  │
│  (OpenWeatherMap)   │     │  (SharedPrefs)   │
└──────┬──────────────┘     └────────┬─────────┘
       ↓                              ↓
   WeatherModel ←───────────────────────
       ↓
   WeatherEntity
       ↓
   Either<Failure, WeatherEntity>
       ↓
┌─────────────────────┐
│ WeatherController   │ Updates state
└──────┬──────────────┘
       ↓
┌─────────────┐
│  HomePage   │ UI re-renders
└─────────────┘
```

## Dependency Injection

GeoWeather uses **GetX** for dependency injection with a two-level setup:

### 1. Global Dependencies (`injection_container.dart`)

Registered once at app startup:

```dart
Future<void> setupServiceLocator() async {
  // External packages
  Get.put(Dio());
  Get.put(Connectivity());
  
  // Core services (available app-wide)
  Get.put<NetworkInfo>(NetworkInfoImpl(Get.find()));
  Get.put<DioClient>(DioClient(Get.find()));
  Get.put<StorageService>(StorageServiceImpl(Get.find()));
  Get.put<LocationService>(LocationServiceImpl());
  
  // Environment config
  Get.put<String>(Env.apiKey, tag: 'apiKey');
}
```

### 2. Feature Dependencies (Bindings)

Lazy-loaded per feature/route:

```dart
class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    // Datasources
    Get.lazyPut<WeatherRemoteDatasource>(
      () => WeatherRemoteDatasourceImpl(Get.find()),
    );
    
    // Repository
    Get.lazyPut<WeatherRepository>(
      () => WeatherRepositoryImpl(
        remoteDatasource: Get.find(),
        localDatasource: Get.find(),
      ),
    );
    
    // Use cases
    Get.lazyPut(() => GetCurrentWeather(Get.find()));
    
    // Controller
    Get.put(WeatherController(
      getCurrentWeather: Get.find(),
    ));
  }
}
```

**Benefits**:
- Global services available everywhere
- Feature dependencies loaded only when needed
- Easy to test (can inject mocks)
- Clear dependency graph

## State Management

### GetX Reactive Pattern

We use GetX's reactive state management:

```dart
class WeatherController extends GetxController {
  // Reactive observables
  final isLoading = false.obs;
  final weather = Rx<WeatherEntity?>(null);
  final error = Rx<String?>(null);
  
  // Methods update observables
  Future<void> fetchWeather() async {
    isLoading.value = true;
    // ... fetch logic
    weather.value = result;
    isLoading.value = false;
  }
}
```

### UI Reactivity

UI automatically updates when observables change:

```dart
// Reactive widget
Obx(() {
  if (controller.isLoading.value) {
    return LoadingWidget();
  }
  
  if (controller.error.value != null) {
    return ErrorWidget(controller.error.value!);
  }
  
  return WeatherDisplay(controller.weather.value!);
})
```

### Resource Wrapper (Advanced)

For more complex state management, we provide a `Resource<T>` wrapper:

```dart
final weatherState = Rx<Resource<WeatherEntity>>(Resource.initial());

// Usage
weatherState.value.when(
  initial: () => Text('Start search'),
  loading: () => CircularProgressIndicator(),
  success: (data) => WeatherWidget(data),
  error: (msg) => ErrorWidget(msg),
);
```

## Error Handling

### Two-Level Error System

**1. Exceptions (Data Layer)**

Thrown by datasources and caught by repositories:

```dart
// Defined in core/errors/exceptions.dart
class NetworkException extends AppException {
  NetworkException({required String message});
}
```

**2. Failures (Domain Layer)**

Returned to use cases and controllers:

```dart
// Defined in core/errors/failures.dart
abstract class Failure {
  final String message;
}

class NetworkFailure extends Failure {
  NetworkFailure({String message = 'Network error'});
}
```

### Error Flow

```
API Error
  ↓
Dio throws DioException
  ↓
DioClient converts to AppException
  ↓
Datasource throws NetworkException
  ↓
Repository catches and converts to Failure
  ↓
Use Case returns Either<Failure, Data>
  ↓
Controller handles failure
  ↓
UI shows error message
```

### Using Either for Error Handling

We use `dartz` package's `Either<L, R>` type:

```dart
// Left = Failure, Right = Success
Future<Either<Failure, WeatherEntity>> getWeather() async {
  try {
    final data = await datasource.fetchWeather();
    return Right(data); // Success
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message)); // Failure
  }
}

// In controller
result.fold(
  (failure) => error.value = failure.message,  // Handle error
  (data) => weather.value = data,              // Handle success
);
```

## Caching Strategy

### Multi-Level Caching

**1. Network-First with Fallback**

```dart
if (await networkInfo.isConnected) {
  // Try to fetch fresh data from API
  final fresh = await remoteDatasource.get();
  await localDatasource.cache(fresh); // Cache for later
  return Right(fresh);
} else {
  // Offline: return cached data
  final cached = await localDatasource.get();
  return cached != null 
    ? Right(cached)
    : Left(NetworkFailure('No cached data'));
}
```

**2. Cache Expiration**

Cached data has a 30-minute expiration:

```dart
class WeatherLocalDatasourceImpl {
  static const Duration cacheExpiration = Duration(minutes: 30);
  
  Future<bool> isCacheValid(String key) async {
    final timestamp = await getTimestamp(key);
    final age = DateTime.now().difference(timestamp);
    return age < cacheExpiration;
  }
}
```

**3. Stale-While-Revalidate**

Show stale data while fetching fresh:

```dart
// Show cached data immediately
final cached = await localDatasource.getCachedWeatherStale(key);
if (cached != null) {
  weather.value = cached;
}

// Fetch fresh data in background
final fresh = await remoteDatasource.get();
weather.value = fresh;
```

### Cache Keys

Organized for efficient lookup:

- Location-based: `weather_{lat}_{lon}`
- City-based: `weather_{cityName}`
- Timestamp: `weather_{key}_timestamp`

## Testing Strategy

### Unit Tests

Test each layer in isolation:

**Domain Layer** (easiest to test):
```dart
test('GetCurrentWeather returns weather entity', () async {
  // Arrange
  final mockRepo = MockWeatherRepository();
  final useCase = GetCurrentWeather(mockRepo);
  
  when(mockRepo.getCurrentWeather(any, any))
    .thenAnswer((_) async => Right(weatherEntity));
  
  // Act
  final result = await useCase(params);
  
  // Assert
  expect(result, Right(weatherEntity));
});
```

**Data Layer**:
```dart
test('Repository returns cached data when offline', () async {
  // Arrange
  when(networkInfo.isConnected).thenAnswer((_) async => false);
  when(localDatasource.getCached(any))
    .thenAnswer((_) async => weatherModel);
  
  // Act
  final result = await repository.getWeather();
  
  // Assert
  expect(result, Right(weatherModel));
  verify(localDatasource.getCached(any)).called(1);
  verifyNever(remoteDatasource.get(any));
});
```

**Presentation Layer**:
```dart
test('Controller sets loading state during fetch', () async {
  // Arrange
  when(useCase.call(any)).thenAnswer(
    (_) async => Right(weatherEntity),
  );
  
  // Act
  final future = controller.fetchWeather();
  expect(controller.isLoading.value, true);
  
  await future;
  expect(controller.isLoading.value, false);
  expect(controller.weather.value, weatherEntity);
});
```

### Widget Tests

Test UI components:

```dart
testWidgets('Shows loading indicator while fetching', (tester) async {
  // Arrange
  controller.isLoading.value = true;
  
  // Act
  await tester.pumpWidget(HomePage());
  
  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Integration Tests

Test full user flows:

```dart
testWidgets('Full weather fetch flow', (tester) async {
  // Simulate app startup and navigation
  await tester.pumpWidget(MyApp());
  
  // Wait for initial load
  await tester.pumpAndSettle();
  
  // Verify weather is displayed
  expect(find.text('London'), findsOneWidget);
  
  // Pull to refresh
  await tester.drag(find.byType(ListView), Offset(0, 300));
  await tester.pumpAndSettle();
  
  // Verify loading and new data
  expect(find.byType(RefreshIndicator), findsOneWidget);
});
```

## Best Practices

### 1. Keep Domain Layer Pure

✅ **Good**:
```dart
class WeatherEntity {
  final String city;
  final double temperature;
}
```

❌ **Bad**:
```dart
import 'package:flutter/material.dart'; // Don't import Flutter!

class WeatherEntity {
  Widget buildWidget() { ... } // UI logic doesn't belong here
}
```

### 2. Use Cases for Business Logic

✅ **Good**:
```dart
class CalculateHeatIndex extends UseCase<double, Params> {
  @override
  Future<Either<Failure, double>> call(Params params) {
    // Complex calculation logic
    final heatIndex = calculateHeatIndex(
      params.temperature,
      params.humidity,
    );
    return Right(heatIndex);
  }
}
```

❌ **Bad**:
```dart
class WeatherController {
  void showWeather() {
    // Business logic in controller
    final heatIndex = (temp + humidity) / 2; // Too simplistic
    weather.value = ...;
  }
}
```

### 3. Single Responsibility

Each class should do one thing:

- ✅ `WeatherRemoteDatasource`: Only fetch from API
- ✅ `WeatherLocalDatasource`: Only handle cache
- ✅ `WeatherRepository`: Coordinate between them
- ❌ `WeatherService`: Does everything (anti-pattern)

### 4. Dependency Inversion

Depend on abstractions, not concretions:

✅ **Good**:
```dart
class WeatherController {
  final GetCurrentWeather getCurrentWeather; // Depends on use case
}
```

❌ **Bad**:
```dart
class WeatherController {
  final DioClient dio; // Depends on implementation detail
  
  void fetch() {
    dio.get('/weather'); // Controller knows about HTTP
  }
}
```

### 5. Meaningful Comments

Write comments that explain *why*, not *what*:

✅ **Good**:
```dart
// Using 30-minute cache to balance freshness with API quota limits
static const cacheExpiration = Duration(minutes: 30);
```

❌ **Bad**:
```dart
// Set timeout to 10 seconds
const timeout = 10; // What we can already see in the code
```

### 6. Error Messages for Users

Provide actionable error messages:

✅ **Good**:
```dart
'Unable to get your location. Please enable location permissions in Settings.'
```

❌ **Bad**:
```dart
'LocationException: null pointer at line 42' // Technical jargon
```

## Adding New Features

Follow this checklist when adding a new feature:

1. **Create feature folder structure**:
```
lib/features/your_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bindings/
    ├── controllers/
    ├── pages/
    └── widgets/
```

2. **Define domain first** (entities, repository interface, use cases)
3. **Implement data layer** (models, repository, datasources)
4. **Build presentation** (controller, pages, widgets)
5. **Set up dependency injection** (binding)
6. **Add route** in `app_routes.dart` and `app_pages.dart`
7. **Write tests** for each layer

## Conclusion

This architecture provides a solid foundation for building scalable, maintainable Flutter applications. By following Clean Architecture principles and leveraging GetX for state management, we achieve:

- Clear separation of concerns
- Highly testable code
- Easy to onboard new developers
- Flexible and maintainable codebase
- Consistent patterns across features

Remember: **Good architecture is not about being clever, it's about being clear.**

---

For questions or suggestions about this architecture, please open an issue or contact the development team.
