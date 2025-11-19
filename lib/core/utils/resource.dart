/// Generic wrapper class for representing asynchronous operation states.
/// 
/// This class provides a type-safe way to handle loading, success, and error
/// states in the UI layer. It's particularly useful with reactive state management
/// like GetX, replacing the need for separate loading, error, and data observables.
/// 
/// Benefits:
/// - Single observable for all states
/// - Type-safe data access
/// - Clear state transitions
/// - Easy to handle in UI with pattern matching
/// 
/// Example usage:
/// ```dart
/// final weatherState = Rx<Resource<WeatherEntity>>(Resource.loading());
/// 
/// // In repository:
/// weatherState.value = Resource.loading();
/// final result = await fetchWeather();
/// result.fold(
///   (failure) => weatherState.value = Resource.error(failure.message),
///   (data) => weatherState.value = Resource.success(data),
/// );
/// 
/// // In UI:
/// Obx(() => weatherState.value.when(
///   loading: () => CircularProgressIndicator(),
///   success: (data) => WeatherWidget(data),
///   error: (message) => ErrorWidget(message),
/// ));
/// ```
class Resource<T> {
  final ResourceState state;
  final T? data;
  final String? message;

  const Resource._({
    required this.state,
    this.data,
    this.message,
  });

  /// Creates a loading state resource.
  /// 
  /// Used when an asynchronous operation is in progress.
  /// Optionally can include previously loaded data for optimistic updates.
  factory Resource.loading({T? data}) {
    return Resource._(
      state: ResourceState.loading,
      data: data,
    );
  }

  /// Creates a success state resource with data.
  /// 
  /// Used when an operation completes successfully.
  factory Resource.success(T data) {
    return Resource._(
      state: ResourceState.success,
      data: data,
    );
  }

  /// Creates an error state resource with an error message.
  /// 
  /// Used when an operation fails.
  /// Optionally can include previously loaded data to show stale data.
  factory Resource.error(String message, {T? data}) {
    return Resource._(
      state: ResourceState.error,
      message: message,
      data: data,
    );
  }

  /// Creates an initial/idle state resource.
  /// 
  /// Used when no operation has been started yet.
  factory Resource.initial() {
    return const Resource._(
      state: ResourceState.initial,
    );
  }

  // Convenience getters for checking state
  bool get isLoading => state == ResourceState.loading;
  bool get isSuccess => state == ResourceState.success;
  bool get isError => state == ResourceState.error;
  bool get isInitial => state == ResourceState.initial;

  /// Pattern matching method for handling different states.
  /// 
  /// This provides a clean way to handle all possible states in the UI.
  /// 
  /// Example:
  /// ```dart
  /// resource.when(
  ///   initial: () => Text('No data yet'),
  ///   loading: () => CircularProgressIndicator(),
  ///   success: (data) => DataWidget(data),
  ///   error: (message) => ErrorWidget(message),
  /// );
  /// ```
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) error,
  }) {
    switch (state) {
      case ResourceState.initial:
        return initial();
      case ResourceState.loading:
        return loading();
      case ResourceState.success:
        return success(data as T);
      case ResourceState.error:
        return error(message ?? 'An error occurred');
    }
  }

  /// Optional pattern matching - only handles states you care about.
  /// 
  /// Useful when you want to handle specific states differently
  /// and have a default for others.
  /// 
  /// Example:
  /// ```dart
  /// resource.maybeWhen(
  ///   success: (data) => DataWidget(data),
  ///   orElse: () => LoadingWidget(),
  /// );
  /// ```
  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(String message)? error,
    required R Function() orElse,
  }) {
    switch (state) {
      case ResourceState.initial:
        return initial?.call() ?? orElse();
      case ResourceState.loading:
        return loading?.call() ?? orElse();
      case ResourceState.success:
        return success?.call(data as T) ?? orElse();
      case ResourceState.error:
        return error?.call(message ?? 'An error occurred') ?? orElse();
    }
  }

  @override
  String toString() {
    return 'Resource(state: $state, data: $data, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Resource<T> &&
        other.state == state &&
        other.data == data &&
        other.message == message;
  }

  @override
  int get hashCode => state.hashCode ^ data.hashCode ^ message.hashCode;
}

/// Enum representing the possible states of a Resource.
enum ResourceState {
  /// Initial state before any operation
  initial,
  
  /// Operation is in progress
  loading,
  
  /// Operation completed successfully
  success,
  
  /// Operation failed with an error
  error,
}
