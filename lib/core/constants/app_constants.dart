// lib/core/constants/app_constants.dart
//
// Application-wide string and numeric constants.
// Add new constants here rather than using hardcoded values in code.

/// Application-wide constants.
class AppConstants {
  /// The app display name shown in the AppBar and window title.
  static const String appName = 'Victor Todo';

  /// Default database file name written to the application directory.
  static const String databaseFileName = 'victor_todo.db';

  /// Maximum length for a task title.
  static const int taskTitleMaxLength = 500;

  /// Maximum length for a category name.
  static const int categoryNameMaxLength = 255;

  /// Maximum length for a tag name.
  static const int tagNameMaxLength = 100;

  /// Maximum length for a task list name.
  static const int taskListNameMaxLength = 255;

  /// All Tasks virtual list ID — no database row; UI concept only.
  static const String allTasksListId = '__all_tasks__';
}
