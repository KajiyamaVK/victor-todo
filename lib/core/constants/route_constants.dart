// lib/core/constants/route_constants.dart
//
// Named route paths used by the app router.
// All route strings are centralised here — never hardcode route strings in
// widgets or screens.

/// Route path constants for the app router.
///
/// Paths starting with '/' are top-level routes.
/// Sub-paths (e.g., taskDetail) are relative to their parent.
class RouteConstants {
  // Top-level routes.
  /// Home screen — shows all tasks.
  static const String home = '/';

  /// Task detail screen — create or edit a task.
  static const String taskDetail = '/task-detail';

  /// Task list screen — tasks filtered by a named list.
  static const String taskList = '/task-list';

  /// Categories management screen.
  static const String categories = '/categories';

  /// Settings screen (placeholder).
  static const String settings = '/settings';
}
