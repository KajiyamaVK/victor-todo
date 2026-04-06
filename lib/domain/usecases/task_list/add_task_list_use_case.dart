// lib/domain/usecases/task_list/add_task_list_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/entities/task_list.dart';
import 'package:taskem/domain/repositories/task_list_repository.dart';

/// Adds a new task list to the repository after validating business rules.
///
/// Business rule: list name must not be empty.
class AddTaskListUseCase {
  /// Creates an [AddTaskListUseCase] with the given [repository].
  const AddTaskListUseCase(this._repository);

  final TaskListRepository _repository;

  /// Validates [taskList] and adds it to the repository.
  ///
  /// Throws [ArgumentError] if the list name is empty.
  Future<void> execute(TaskList taskList) {
    if (taskList.name.trim().isEmpty) {
      throw ArgumentError.value(
        taskList.name,
        'name',
        'Task list name must not be empty.',
      );
    }
    return _repository.addTaskList(taskList);
  }
}
