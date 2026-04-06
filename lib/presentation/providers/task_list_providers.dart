// lib/presentation/providers/task_list_providers.dart
//
// Riverpod providers for named-task-list use cases and state.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:taskem/data/repositories/task_list_repository_impl.dart';
import 'package:taskem/domain/entities/task_list.dart';
import 'package:taskem/domain/repositories/task_list_repository.dart';
import 'package:taskem/domain/usecases/task_list/add_task_list_use_case.dart';
import 'package:taskem/domain/usecases/task_list/get_task_lists_use_case.dart';
import 'database_provider.dart';

part 'task_list_providers.g.dart';

/// Provides the concrete [TaskListRepository] backed by drift.
@riverpod
TaskListRepository taskListRepository(Ref ref) {
  final db = ref.watch(databaseProvider);
  return TaskListRepositoryImpl(db.taskListDao);
}

/// Provides [AddTaskListUseCase].
@riverpod
AddTaskListUseCase addTaskListUseCase(Ref ref) {
  return AddTaskListUseCase(ref.watch(taskListRepositoryProvider));
}

/// Provides [GetTaskListsUseCase].
@riverpod
GetTaskListsUseCase getTaskListsUseCase(Ref ref) {
  return GetTaskListsUseCase(ref.watch(taskListRepositoryProvider));
}

/// AsyncNotifier that holds the list of named task lists.
@riverpod
class TaskListsNotifier extends _$TaskListsNotifier {
  @override
  Future<List<TaskList>> build() async {
    return ref.watch(getTaskListsUseCaseProvider).execute();
  }

  /// Adds a task list and refreshes the list.
  Future<void> addTaskList(TaskList taskList) async {
    await ref.read(addTaskListUseCaseProvider).execute(taskList);
    ref.invalidateSelf();
  }
}
