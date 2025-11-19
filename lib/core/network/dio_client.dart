import 'package:dio/dio.dart';
import 'package:geo_weather/core/constants/api_constants.dart';
import 'package:geo_weather/core/errors/exceptions.dart';
import 'package:geo_weather/core/services/logger_service.dart';

/// Centralized HTTP client wrapper using Dio for all network requests.
/// 
/// This class provides a single, configured instance of Dio with:
/// - Base URL configuration
/// - Timeout settings
/// - Request/response interceptors
/// - Comprehensive error handling
/// - Logging for debugging
/// 
/// Benefits:
/// - Consistent configuration across all API calls
/// - Centralized error handling and conversion to app exceptions
/// - Easy to add authentication, headers, or other cross-cutting concerns
/// - Simplified testing (can mock the DioClient)
class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _setupDio();
  }

  /// Configures the Dio instance with app-wide settings.
  /// 
  /// Sets up:
  /// - Base URL for all API calls
  /// - Connection and receive timeouts
  /// - Default headers and response type
  /// - Interceptors for logging and error handling
  void _setupDio() {
    // Configure base options that apply to all requests
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(seconds: ApiConstants.receiveTimeout),
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    // Add interceptors for cross-cutting concerns
    _dio.interceptors.add(
      InterceptorsWrapper(
        // Called before a request is sent
        onRequest: (options, handler) {
          LoggerService.network(
            'Sending request',
            method: options.method,
            url: '${options.baseUrl}${options.path}',
          );
          LoggerService.debug('Query params: ${options.queryParameters}');
          return handler.next(options);
        },
        
        // Called when a response is received
        onResponse: (response, handler) {
          LoggerService.network(
            'Received response',
            method: response.requestOptions.method,
            url: response.requestOptions.uri.toString(),
            statusCode: response.statusCode,
          );
          return handler.next(response);
        },
        
        // Called when an error occurs
        onError: (error, handler) {
          LoggerService.error(
            'Request failed',
            tag: 'DioClient',
            error: error.message,
          );
          return handler.next(error);
        },
      ),
    );
  }

  /// Makes a GET request to the specified path.
  /// 
  /// Parameters:
  /// - [path]: The endpoint path (will be appended to base URL)
  /// - [queryParameters]: Optional query parameters
  /// - [options]: Optional request options to override defaults
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Throws:
  /// - [TimeoutException]: If the request times out
  /// - [ApiException]: For API-specific errors (4xx, 5xx)
  /// - [NetworkException]: For network connectivity issues
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      LoggerService.error('Unexpected error in GET request', error: e);
      rethrow;
    }
  }

  /// Makes a POST request to the specified path.
  /// 
  /// Used for creating resources or sending data to the server.
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      LoggerService.error('Unexpected error in POST request', error: e);
      rethrow;
    }
  }

  /// Makes a PUT request to the specified path.
  /// 
  /// Typically used for updating existing resources.
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      LoggerService.error('Unexpected error in PUT request', error: e);
      rethrow;
    }
  }

  /// Makes a DELETE request to the specified path.
  /// 
  /// Used for deleting resources from the server.
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      LoggerService.error('Unexpected error in DELETE request', error: e);
      rethrow;
    }
  }

  /// Converts Dio exceptions to our custom app exceptions.
  /// 
  /// This centralizes error handling and provides meaningful error messages
  /// that can be displayed to users or used for recovery logic.
  void _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        LoggerService.warning('Request timed out', tag: 'DioClient');
        throw TimeoutException(message: ApiConstants.timeoutError);
        
      case DioExceptionType.badResponse:
        // Server responded with an error status code
        final statusCode = e.response?.statusCode;
        final message = _getErrorMessageFromResponse(e.response);
        LoggerService.error(
          'Bad response from server',
          tag: 'DioClient',
          error: 'Status: $statusCode, Message: $message',
        );
        throw ApiException(
          message: message,
          statusCode: statusCode,
        );
        
      case DioExceptionType.cancel:
        LoggerService.info('Request was cancelled', tag: 'DioClient');
        throw NetworkException(message: 'Request cancelled');
        
      case DioExceptionType.connectionError:
        LoggerService.error('Connection error occurred', tag: 'DioClient');
        throw NetworkException(message: ApiConstants.networkError);
        
      default:
        LoggerService.error('Unknown network error', tag: 'DioClient', error: e.message);
        throw NetworkException(message: e.message ?? ApiConstants.networkError);
    }
  }

  /// Extracts a user-friendly error message from the API response.
  /// 
  /// Many APIs return error details in the response body.
  /// This method attempts to extract and format those messages.
  String _getErrorMessageFromResponse(Response? response) {
    if (response == null) return ApiConstants.networkError;
    
    try {
      // Try to extract error message from response data
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        
        // Common error message fields in APIs
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data.containsKey('error')) {
          return data['error'].toString();
        }
        if (data.containsKey('detail')) {
          return data['detail'].toString();
        }
      }
    } catch (e) {
      LoggerService.warning('Could not parse error response', tag: 'DioClient');
    }
    
    // Fallback to status-based messages
    final statusCode = response.statusCode;
    if (statusCode == 401) return 'Invalid API key or unauthorized access';
    if (statusCode == 404) return 'Resource not found';
    if (statusCode == 429) return 'Too many requests. Please try again later';
    if (statusCode != null && statusCode >= 500) return 'Server error occurred';
    
    return response.statusMessage ?? ApiConstants.networkError;
  }
}

