// lib/data/repositories/task_repository_impl.dart
//
// Concrete implementation of TaskRepository using drift DAOs.

import 'package:drift/drift.dart' show Value;

import 'package:taskem/data/datasources/daos/task_dao.dart';
import 'package:taskem/data/datasources/database/app_database.dart'
    show TaskTagsCompanion;
import 'package:taskem/data/mappers/task_mapper.dart';
import 'package:taskem/domain/entities/task.dart' as domain show Task;
import 'package:taskem/domain/repositories/task_repository.dart';

/// Concrete implementation of [TaskRepository] using drift DAOs.
///
/// Depends on [TaskDao] for task CRUD operations and the tag-related methods
/// (getTagIdsForTask, insertTaskTag, deleteTagsForTask) which are bundled
/// in the same DAO to keep the many-to-many join logic together.
class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this._taskDao);

  final TaskDao _taskDao;

  @override
  Future<List<domain.Task>> getAllTasks() async {
    final rows = await _taskDao.getAllTasks();
    return Future.wait(
      rows.map((row) async {
        final tagIds = await _taskDao.getTagIdsForTask(row.id);
        return TaskMapper.toDomain(row, tagIds);
      }),
    );
  }

  @override
  Future<List<domain.Task>> getTasksByList(String listId) async {
    final rows = await _taskDao.getTasksByList(listId);
    return Future.wait(
      rows.map((row) async {
        final tagIds = await _taskDao.getTagIdsForTask(row.id);
        return TaskMapper.toDomain(row, tagIds);
      }),
    );
  }

  @override
  Future<domain.Task?> getTaskById(String id) async {
    final row = await _taskDao.getTaskById(id);
    if (row == null) return null;
    final tagIds = await _taskDao.getTagIdsForTask(id);
    return TaskMapper.toDomain(row, tagIds);
  }

  @override
  Future<void> addTask(domain.Task task) async {
    await _taskDao.insertTask(TaskMapper.toCompanion(task));
    // Insert task-tag associations.
    for (final tagId in task.tagIds) {
      await _taskDao.insertTaskTag(
        TaskTagsCompanion(
          taskId: Value(task.id),
          tagId: Value(tagId),
        ),
      );
    }
  }

  @override
  Future<void> updateTask(domain.Task task) async {
    await _taskDao.updateTask(TaskMapper.toCompanion(task));
    // Replace all tag associations for this task.
    await _taskDao.deleteTagsForTask(task.id);
    for (final tagId in task.tagIds) {
      await _taskDao.insertTaskTag(
        TaskTagsCompanion(
          taskId: Value(task.id),
          tagId: Value(tagId),
        ),
      );
    }
  }

  @override
  Future<void> deleteTask(String id) => _taskDao.deleteTask(id);
}
