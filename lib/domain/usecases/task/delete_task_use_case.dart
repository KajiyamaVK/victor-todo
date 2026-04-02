// lib/domain/usecases/task/delete_task_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/repositories/task_repository.dart';

/// Deletes a task from the repository and cancels its scheduled notification.
///
/// Accepts a [cancelReminder] callback instead of importing the notification
/// service directly, keeping this use case pure Dart and easily testable.
class DeleteTaskUseCase {
  /// Creates a [DeleteTaskUseCase].
  ///
  /// [repository]     — the task data source.
  /// [cancelReminder] — callback that cancels a notification by integer id.
  const DeleteTaskUseCase(this._repository, this._cancelReminder);

  final TaskRepository _repository;

  /// Callback invoked to cancel the scheduled notification for the task.
  final Future<void> Function(int notificationId) _cancelReminder;

  /// Deletes the task with [id] and cancels its notification.
  ///
  /// No-op (does not throw) if no task exists with the given [id].
  Future<void> execute(String id) async {
    await _repository.deleteTask(id);
    await _cancelReminder(id.hashCode);
  }
}
