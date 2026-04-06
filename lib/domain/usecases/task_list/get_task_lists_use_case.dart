// lib/domain/usecases/task_list/get_task_lists_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/entities/task_list.dart';
import 'package:taskem/domain/repositories/task_list_repository.dart';

/// Returns all task lists.
class GetTaskListsUseCase {
  /// Creates a [GetTaskListsUseCase] with the given [repository].
  const GetTaskListsUseCase(this._repository);

  final TaskListRepository _repository;

  /// Fetches all task lists from the repository.
  Future<List<TaskList>> execute() => _repository.getAllTaskLists();
}
