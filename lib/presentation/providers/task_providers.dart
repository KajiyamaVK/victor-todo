// lib/presentation/providers/task_providers.dart
//
// Riverpod providers for task-related use cases and state.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:taskem/data/repositories/task_repository_impl.dart';
import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/domain/repositories/task_repository.dart';
import 'package:taskem/domain/usecases/task/add_task_use_case.dart';
import 'package:taskem/domain/usecases/task/complete_task_use_case.dart';
import 'package:taskem/domain/usecases/task/delete_task_use_case.dart';
import 'package:taskem/domain/usecases/task/get_tasks_by_list_use_case.dart';
import 'package:taskem/domain/usecases/task/get_tasks_use_case.dart';
import 'package:taskem/domain/usecases/task/update_task_use_case.dart';
import 'package:taskem/services/notification_service.dart';
import 'database_provider.dart';

part 'task_providers.g.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

/// Provides the concrete [TaskRepository] backed by drift DAOs.
///
/// The presentation layer accesses tasks through this provider —
/// never by importing from [data/] directly.
@riverpod
TaskRepository taskRepository(Ref ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepositoryImpl(db.taskDao);
}

// ---------------------------------------------------------------------------
// Use case providers
// ---------------------------------------------------------------------------

/// Provides [AddTaskUseCase].
@riverpod
AddTaskUseCase addTaskUseCase(Ref ref) {
  return AddTaskUseCase(ref.watch(taskRepositoryProvider));
}

/// Provides [UpdateTaskUseCase].
@riverpod
UpdateTaskUseCase updateTaskUseCase(Ref ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
}

/// Provides [GetTasksUseCase].
@riverpod
GetTasksUseCase getTasksUseCase(Ref ref) {
  return GetTasksUseCase(ref.watch(taskRepositoryProvider));
}

/// Provides [GetTasksByListUseCase].
@riverpod
GetTasksByListUseCase getTasksByListUseCase(Ref ref) {
  return GetTasksByListUseCase(ref.watch(taskRepositoryProvider));
}

/// Provides [DeleteTaskUseCase] wired to [NotificationService].
@riverpod
DeleteTaskUseCase deleteTaskUseCase(Ref ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return DeleteTaskUseCase(
    ref.watch(taskRepositoryProvider),
    notificationService.cancelReminder,
  );
}

/// Provides [CompleteTaskUseCase] wired to [NotificationService].
@riverpod
CompleteTaskUseCase completeTaskUseCase(Ref ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return CompleteTaskUseCase(
    ref.watch(taskRepositoryProvider),
    notificationService.cancelReminder,
  );
}

// ---------------------------------------------------------------------------
// Task list state notifier
// ---------------------------------------------------------------------------

/// AsyncNotifier that holds and manages the list of all tasks.
///
/// Exposes methods for adding, updating, completing, and deleting tasks.
/// The notifier invalidates itself after each mutation to refresh the list.
@riverpod
class TaskListNotifier extends _$TaskListNotifier {
  @override
  Future<List<Task>> build() async {
    return ref.watch(getTasksUseCaseProvider).execute();
  }

  /// Adds a new task and refreshes the list.
  Future<void> addTask(Task task) async {
    await ref.read(addTaskUseCaseProvider).execute(task);
    ref.invalidateSelf();
  }

  /// Updates an existing task and refreshes the list.
  Future<void> updateTask(Task task) async {
    await ref.read(updateTaskUseCaseProvider).execute(task);
    ref.invalidateSelf();
  }

  /// Marks a task as complete and refreshes the list.
  Future<void> completeTask(String id) async {
    await ref.read(completeTaskUseCaseProvider).execute(id);
    ref.invalidateSelf();
  }

  /// Deletes a task and refreshes the list.
  Future<void> deleteTask(String id) async {
    await ref.read(deleteTaskUseCaseProvider).execute(id);
    ref.invalidateSelf();
  }
}

// ---------------------------------------------------------------------------
// Task-by-list state notifier (family)
// ---------------------------------------------------------------------------

/// AsyncNotifier that holds tasks filtered by a specific named list.
///
/// Takes [listId] as a parameter and provides the same mutation methods
/// as [TaskListNotifier].
@riverpod
class TasksByListNotifier extends _$TasksByListNotifier {
  @override
  Future<List<Task>> build(String listId) async {
    return ref.watch(getTasksByListUseCaseProvider).execute(listId);
  }

  /// Adds a new task and refreshes the filtered list.
  Future<void> addTask(Task task) async {
    await ref.read(addTaskUseCaseProvider).execute(task);
    ref.invalidateSelf();
  }

  /// Marks a task as complete and refreshes the filtered list.
  Future<void> completeTask(String id) async {
    await ref.read(completeTaskUseCaseProvider).execute(id);
    ref.invalidateSelf();
  }

  /// Deletes a task and refreshes the filtered list.
  Future<void> deleteTask(String id) async {
    await ref.read(deleteTaskUseCaseProvider).execute(id);
    ref.invalidateSelf();
  }
}
