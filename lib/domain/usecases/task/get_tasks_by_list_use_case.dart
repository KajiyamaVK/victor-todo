// lib/domain/usecases/task/get_tasks_by_list_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/task.dart';
import 'package:victor_todo/domain/repositories/task_repository.dart';

/// Returns all tasks that belong to a specific named list.
class GetTasksByListUseCase {
  /// Creates a [GetTasksByListUseCase] with the given [repository].
  const GetTasksByListUseCase(this._repository);

  final TaskRepository _repository;

  /// Fetches tasks filtered by [listId].
  Future<List<Task>> execute(String listId) =>
      _repository.getTasksByList(listId);
}
