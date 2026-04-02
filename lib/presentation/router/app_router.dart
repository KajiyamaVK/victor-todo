// lib/presentation/router/app_router.dart
//
// Defines the GoRouter configuration for the app.
// All route paths are defined in RouteConstants — do not hardcode paths here.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:victor_todo/core/constants/route_constants.dart';
import 'package:victor_todo/presentation/screens/categories/categories_screen.dart';
import 'package:victor_todo/presentation/screens/home/home_screen.dart';
import 'package:victor_todo/presentation/screens/settings/settings_screen.dart';
import 'package:victor_todo/presentation/screens/task_detail/task_detail_screen.dart';
import 'package:victor_todo/presentation/screens/task_list/task_list_screen.dart';

/// Application router — thin wrapper around [GoRouter].
///
/// Access the router via [AppRouter.router]. All routes and their parameters
/// are declared here and mapped to screen classes.
class AppRouter {
  const AppRouter._();

  /// The singleton [GoRouter] instance.
  static final router = GoRouter(
    initialLocation: RouteConstants.home,
    routes: [
      // Home — all tasks view.
      GoRoute(
        path: RouteConstants.home,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),

      // Task detail — create new task or edit existing one.
      // Optional query param: taskId (if editing).
      GoRoute(
        path: RouteConstants.taskDetail,
        builder: (BuildContext context, GoRouterState state) {
          final taskId = state.uri.queryParameters['taskId'];
          return TaskDetailScreen(taskId: taskId);
        },
      ),

      // Task list — tasks filtered by a named list.
      // Required query param: listId.
      GoRoute(
        path: RouteConstants.taskList,
        builder: (BuildContext context, GoRouterState state) {
          final listId = state.uri.queryParameters['listId'] ?? '';
          return TaskListScreen(listId: listId);
        },
      ),

      // Categories management.
      GoRoute(
        path: RouteConstants.categories,
        builder: (BuildContext context, GoRouterState state) =>
            const CategoriesScreen(),
      ),

      // Settings placeholder.
      GoRoute(
        path: RouteConstants.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
    ],
  );
}
