/// API endpoints configuration
/// Centralized location for all API endpoints
class ApiEndpoint {
  // Private constructor to prevent instantiation
  ApiEndpoint._();

  // Base URL
  // TODO: Replace with your actual base URL
  static const String baseUrl = 'https://api.example.com';

  // API Version
  static const String apiVersion = '/v1';

  // Full base URL with version
  static String get baseUrlWithVersion => '$baseUrl$apiVersion';

  // TODO: Add your API endpoints here
  // Example:
  // static const String login = '/auth/login';
  // static const String register = '/auth/register';
  // static const String logout = '/auth/logout';
  // static const String profile = '/user/profile';
  // static const String updateProfile = '/user/profile/update';

  // Auth endpoints
  // static const String login = '$apiVersion/auth/login';
  // static const String register = '$apiVersion/auth/register';
  // static const String refreshToken = '$apiVersion/auth/refresh';
  // static const String logout = '$apiVersion/auth/logout';

  // User endpoints
  // static const String getUserProfile = '$apiVersion/user/profile';
  // static const String updateUserProfile = '$apiVersion/user/profile';
  // static const String deleteUser = '$apiVersion/user/delete';

  // Helper method to build full URL
  static String buildUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}
