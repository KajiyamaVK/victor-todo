// lib/data/datasources/daos/task_dao.dart
//
// Data Access Object for the tasks and task_tags tables.

// ignore: depend_on_referenced_packages
import 'package:drift/drift.dart';

import 'package:victor_todo/data/datasources/database/app_database.dart';

part 'task_dao.g.dart';

/// Data Access Object for the tasks table.
///
/// All query methods return drift-generated data classes ([Task] in drift,
/// aliased here to avoid shadowing the domain Task entity).
/// [TaskMapper] converts these to domain entities.
///
/// Note: drift generates the data class as [Task] (same name as domain entity).
/// This DAO lives in the data layer and only imports drift types, so there is
/// no ambiguity here — domain [Task] is never imported.
@DriftAccessor(tables: [Tasks, TaskTags])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  /// Inserts a new task row.
  Future<void> insertTask(TasksCompanion entry) => into(tasks).insert(entry);

  /// Returns all task rows ordered by due_date ASC, nulls last.
  // ignore: always_declare_return_types
  Future<List<Task>> getAllTasks() => (select(tasks)
        ..orderBy([
          (t) => OrderingTerm(
                expression: t.dueDate,
                mode: OrderingMode.asc,
                nulls: NullsOrder.last,
              ),
        ]))
      .get();

  /// Returns all task rows belonging to the given [listId].
  Future<List<Task>> getTasksByList(String listId) =>
      (select(tasks)..where((t) => t.taskListId.equals(listId))).get();

  /// Returns the task row with the given [id], or null if not found.
  Future<Task?> getTaskById(String id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Updates an existing task row (matches by id).
  Future<void> updateTask(TasksCompanion entry) =>
      (update(tasks)..where((t) => t.id.equals(entry.id.value))).write(entry);

  /// Deletes the task row with the given [id].
  Future<void> deleteTask(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // TaskTags methods
  // ---------------------------------------------------------------------------

  /// Returns all tag ids attached to task [taskId].
  Future<List<String>> getTagIdsForTask(String taskId) async {
    final rows =
        await (select(taskTags)..where((tt) => tt.taskId.equals(taskId))).get();
    return rows.map((r) => r.tagId).toList();
  }

  /// Inserts a task-tag association row.
  Future<void> insertTaskTag(TaskTagsCompanion entry) =>
      into(taskTags).insert(entry);

  /// Deletes all tag associations for the given [taskId].
  Future<void> deleteTagsForTask(String taskId) =>
      (delete(taskTags)..where((tt) => tt.taskId.equals(taskId))).go();
}
