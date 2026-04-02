// lib/domain/repositories/task_repository.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/task.dart';

/// Abstract interface for task persistence.
///
/// Implemented by [TaskRepositoryImpl] in the data layer.
/// All methods return domain entities, never drift data classes.
/// The presentation layer depends only on this interface (via Riverpod providers),
/// never on the concrete implementation.
abstract class TaskRepository {
  /// Returns all tasks sorted by due date ascending. Null dates appear last.
  Future<List<Task>> getAllTasks();

  /// Returns all tasks belonging to the given [listId].
  Future<List<Task>> getTasksByList(String listId);

  /// Returns the task with the given [id], or null if not found.
  Future<Task?> getTaskById(String id);

  /// Inserts a new task. Throws if a task with the same id already exists.
  Future<void> addTask(Task task);

  /// Updates an existing task. Throws if the task does not exist.
  Future<void> updateTask(Task task);

  /// Deletes the task with the given [id]. No-op if the task does not exist.
  Future<void> deleteTask(String id);
}
