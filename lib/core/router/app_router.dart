import 'package:cr_app/core/common/r_bottom_navbar.dart';
import 'package:cr_app/core/storage/storage_service.dart';
import 'package:cr_app/core/utils/constant.dart';
import 'package:cr_app/features/auth/presentation/views/login_screen/login_screen.dart';
import 'package:cr_app/features/semesters/presentation/views/subject_list_view/subject_list_view.dart';
import 'package:cr_app/features/semesters/presentation/views/resource_list_view/resource_list_view.dart';
import 'package:cr_app/features/settings/presentation/views/about_cr_assistant/about_cr_assistant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/main',
    debugLogDiagnostics: false,

    // Runs before every navigation — decides whether to redirect
    redirect: (context, state) {
      final bool loggedIn = StorageService.containsKey(Constants.keyAuthToken);
      final bool goingToAuth = state.matchedLocation == '/';

      // Not logged in, trying to reach a protected page → send to login
      if (!loggedIn && !goingToAuth) return '/';

      // Already logged in, but trying to open login screen → send to main
      if (loggedIn && goingToAuth) return '/main';

      return null; // No redirect needed
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/subjects',
        name: 'subjects',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SubjectListView(
            semesterId: extra['semesterId'] as int? ?? 0,
            semesterName: extra['semesterName'] as String? ?? 'Subjects',
          );
        },
      ),
      GoRoute(
        path: '/resources',
        name: 'resources',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ResourceListView(
            subjectId: extra['subjectId'] as int? ?? 0,
            subjectName: extra['subjectName'] as String? ?? 'Resources',
          );
        },
      ),

      //ABout CR
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => AboutCrAssistant(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );

  static void go(String path) {
    _router.go(path);
  }

  static Future<T?> push<T extends Object?>(
      String path, {
        Object? extra,
      }) {
    return _router.push<T>(path, extra: extra);
  }

  static void pop<T extends Object?>([T? result]) {
    _router.pop<T>(result);
  }
}