import 'package:dio/dio.dart';

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;

  const AppException(this.message, [this.originalError]);

  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  final int? statusCode;
  final dynamic data;

  const ServerException(
    String message, {
    this.statusCode,
    this.data,
    dynamic originalError,
  }) : super(message, originalError);
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

/// Timeout exception
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timeout'])
      : super(message);
}

/// Cache exception
class CacheException extends AppException {
  const CacheException([String message = 'Cache error'])
      : super(message);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException([String message = 'Validation error'])
      : super(message);
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException([String message = 'Authentication failed'])
      : super(message);
}

/// Exception handler utility
class ExceptionHandler {
  /// Convert DioException to AppException
  static AppException handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ??
            error.response?.statusMessage ??
            'Server error';
        return ServerException(
          message,
          statusCode: statusCode,
          data: error.response?.data,
          originalError: error,
        );

      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');

      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');

      case DioExceptionType.badCertificate:
        return ServerException('Bad certificate');

      case DioExceptionType.unknown:
      default:
        return NetworkException('Unknown network error');
    }
  }

  /// Handle general exceptions
  static AppException handleException(dynamic error) {
    if (error is DioException) {
      return handleDioException(error);
    } else if (error is AppException) {
      return error;
    } else {
      return NetworkException('Unexpected error: ${error.toString()}');
    }
  }
}
