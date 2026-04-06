// lib/data/repositories/task_list_repository_impl.dart
//
// Concrete implementation of TaskListRepository using drift DAO.

import 'package:taskem/data/datasources/daos/task_list_dao.dart';
import 'package:taskem/data/mappers/task_list_mapper.dart';
import 'package:taskem/domain/entities/task_list.dart' as domain show TaskList;
import 'package:taskem/domain/repositories/task_list_repository.dart';

/// Concrete implementation of [TaskListRepository] using [TaskListDao].
class TaskListRepositoryImpl implements TaskListRepository {
  const TaskListRepositoryImpl(this._taskListDao);

  final TaskListDao _taskListDao;

  @override
  Future<List<domain.TaskList>> getAllTaskLists() async {
    final rows = await _taskListDao.getAllTaskLists();
    return rows.map(TaskListMapper.toDomain).toList();
  }

  @override
  Future<domain.TaskList?> getTaskListById(String id) async {
    final row = await _taskListDao.getTaskListById(id);
    return row != null ? TaskListMapper.toDomain(row) : null;
  }

  @override
  Future<void> addTaskList(domain.TaskList taskList) =>
      _taskListDao.insertTaskList(TaskListMapper.toCompanion(taskList));

  @override
  Future<void> updateTaskList(domain.TaskList taskList) =>
      _taskListDao.updateTaskList(TaskListMapper.toCompanion(taskList));

  @override
  Future<void> deleteTaskList(String id) => _taskListDao.deleteTaskList(id);
}
