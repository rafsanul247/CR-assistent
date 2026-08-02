import 'package:cr_app/core/common/r_bottom_navbar.dart';
import 'package:cr_app/features/home/presentation/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App router configuration
/// Provides centralized routing with GoRouter
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  /// Create and configure the router
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainScreen(),
      ),
      // Add your routes here
      // Example:
      // GoRoute(
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );

  /// Navigate to a route by path
  static void go(String path) {
    _router.go(path);
  }

  /// Navigate to a route by name
  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push a route
  static Future<T?> push<T extends Object?>(
    String path, {
    Object? extra,
  }) {
    return _router.push<T>(path, extra: extra);
  }

  /// Push a named route
  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    return _router.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pop the current route
  static void pop<T extends Object?>([T? result]) {
    _router.pop<T>(result);
  }

  /// Check if can pop
  static bool canPop() {
    return _router.canPop();
  }
}
