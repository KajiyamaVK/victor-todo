// lib/domain/usecases/task/complete_task_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/repositories/task_repository.dart';

/// Marks a task as completed and cancels its scheduled notification.
///
/// Accepts a [cancelReminder] callback instead of importing the notification
/// service directly, keeping this use case pure Dart and easily testable.
class CompleteTaskUseCase {
  /// Creates a [CompleteTaskUseCase].
  ///
  /// [repository]     — the task data source.
  /// [cancelReminder] — callback that cancels a notification by integer id.
  ///                    Use [NotificationService.cancelReminder].
  const CompleteTaskUseCase(this._repository, this._cancelReminder);

  final TaskRepository _repository;

  /// Callback invoked to cancel the scheduled notification for the task.
  /// Signature matches [NotificationService.cancelReminder].
  final Future<void> Function(int notificationId) _cancelReminder;

  /// Fetches the task by [id], marks it complete, persists the update,
  /// and cancels any scheduled notification.
  ///
  /// Throws [StateError] if no task exists with the given [id].
  Future<void> execute(String id) async {
    final task = await _repository.getTaskById(id);
    if (task == null) {
      throw StateError('Task with id "$id" not found.');
    }

    // Skip if already completed — idempotent operation.
    if (task.isCompleted) {
      return;
    }

    final updated = task.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.updateTask(updated);

    // Cancel any scheduled notification.
    // Notification ids are derived from the task id's hashCode.
    await _cancelReminder(id.hashCode);
  }
}
