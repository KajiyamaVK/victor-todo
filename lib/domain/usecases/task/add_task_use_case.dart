// lib/domain/usecases/task/add_task_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/domain/repositories/task_repository.dart';

/// Adds a new task to the repository after validating business rules.
///
/// Business rules:
///  - Title must not be empty or whitespace-only.
///  - If a due date is provided, it must not be in the past.
class AddTaskUseCase {
  /// Creates an [AddTaskUseCase] with the given [repository].
  const AddTaskUseCase(this._repository);

  final TaskRepository _repository;

  /// Validates [task] and adds it to the repository.
  ///
  /// Throws [ArgumentError] if:
  ///  - [task.title] is empty or whitespace-only
  ///  - [task.dueDate] is in the past
  Future<void> execute(Task task) {
    _validate(task);
    return _repository.addTask(task);
  }

  void _validate(Task task) {
    if (task.title.trim().isEmpty) {
      throw ArgumentError.value(
        task.title,
        'title',
        'Task title must not be empty.',
      );
    }

    final dueDate = task.dueDate;
    if (dueDate != null && dueDate.isBefore(DateTime.now())) {
      throw ArgumentError.value(
        dueDate,
        'dueDate',
        'Due date must not be in the past.',
      );
    }
  }
}
