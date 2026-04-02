// lib/domain/usecases/task/get_tasks_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/task.dart';
import 'package:victor_todo/domain/repositories/task_repository.dart';

/// Returns all tasks sorted by due date ascending (nulls last).
class GetTasksUseCase {
  /// Creates a [GetTasksUseCase] with the given [repository].
  const GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  /// Fetches all tasks from the repository.
  Future<List<Task>> execute() => _repository.getAllTasks();
}
