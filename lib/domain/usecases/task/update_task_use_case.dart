// lib/domain/usecases/task/update_task_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/domain/repositories/task_repository.dart';

/// Updates an existing task in the repository after validating business rules.
///
/// Business rules:
///  - Title must not be empty or whitespace-only.
///  - If a due date is provided, it must not be in the past.
class UpdateTaskUseCase {
  /// Creates an [UpdateTaskUseCase] with the given [repository].
  const UpdateTaskUseCase(this._repository);

  final TaskRepository _repository;

  /// Validates [task] and persists the update.
  ///
  /// Throws [ArgumentError] if validation fails.
  Future<void> execute(Task task) {
    _validate(task);
    return _repository.updateTask(task);
  }

  void _validate(Task task) {
    if (task.title.trim().isEmpty) {
      throw ArgumentError.value(
        task.title,
        'title',
        'Task title must not be empty.',
      );
    }

    // Only validate future due dates for incomplete tasks.
    final dueDate = task.dueDate;
    if (dueDate != null &&
        !task.isCompleted &&
        dueDate.isBefore(DateTime.now())) {
      throw ArgumentError.value(
        dueDate,
        'dueDate',
        'Due date must not be in the past.',
      );
    }
  }
}
