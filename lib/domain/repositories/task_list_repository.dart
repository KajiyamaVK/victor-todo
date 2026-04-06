// lib/domain/repositories/task_list_repository.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/entities/task_list.dart';

/// Abstract interface for task-list persistence.
///
/// Implemented by [TaskListRepositoryImpl] in the data layer.
abstract class TaskListRepository {
  /// Returns all task lists.
  Future<List<TaskList>> getAllTaskLists();

  /// Returns the task list with the given [id], or null if not found.
  Future<TaskList?> getTaskListById(String id);

  /// Inserts a new task list.
  Future<void> addTaskList(TaskList taskList);

  /// Updates an existing task list.
  Future<void> updateTaskList(TaskList taskList);

  /// Deletes the task list with the given [id].
  Future<void> deleteTaskList(String id);
}
