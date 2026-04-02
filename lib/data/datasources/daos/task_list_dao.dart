// lib/data/datasources/daos/task_list_dao.dart
//
// Data Access Object for the task_lists table.

// ignore: depend_on_referenced_packages
import 'package:drift/drift.dart';

import 'package:victor_todo/data/datasources/database/app_database.dart';

part 'task_list_dao.g.dart';

/// Data Access Object for the task_lists table.
///
/// Note: drift generates the data class as [TaskList].
@DriftAccessor(tables: [TaskLists])
class TaskListDao extends DatabaseAccessor<AppDatabase>
    with _$TaskListDaoMixin {
  TaskListDao(super.db);

  /// Returns all task list rows.
  Future<List<TaskList>> getAllTaskLists() => select(taskLists).get();

  /// Returns the task list row with the given [id], or null.
  Future<TaskList?> getTaskListById(String id) =>
      (select(taskLists)..where((l) => l.id.equals(id))).getSingleOrNull();

  /// Inserts a new task list row.
  Future<void> insertTaskList(TaskListsCompanion entry) =>
      into(taskLists).insert(entry);

  /// Updates an existing task list row (matches by id).
  Future<void> updateTaskList(TaskListsCompanion entry) =>
      (update(taskLists)..where((l) => l.id.equals(entry.id.value)))
          .write(entry);

  /// Deletes the task list row with the given [id].
  Future<void> deleteTaskList(String id) =>
      (delete(taskLists)..where((l) => l.id.equals(id))).go();
}
