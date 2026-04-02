// test/helpers/fake_task_list_repository.dart
//
// In-memory fake implementation of [TaskListRepository] for use in unit tests.

import 'package:victor_todo/domain/entities/task_list.dart';
import 'package:victor_todo/domain/repositories/task_list_repository.dart';

/// In-memory fake implementation of [TaskListRepository].
class FakeTaskListRepository implements TaskListRepository {
  /// The backing store — tests can inspect or seed this directly.
  final List<TaskList> taskLists = [];

  @override
  Future<List<TaskList>> getAllTaskLists() async =>
      List<TaskList>.from(taskLists);

  @override
  Future<TaskList?> getTaskListById(String id) async {
    try {
      return taskLists.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addTaskList(TaskList taskList) async {
    taskLists.add(taskList);
  }

  @override
  Future<void> updateTaskList(TaskList taskList) async {
    final index = taskLists.indexWhere((l) => l.id == taskList.id);
    if (index != -1) {
      taskLists[index] = taskList;
    }
  }

  @override
  Future<void> deleteTaskList(String id) async {
    taskLists.removeWhere((l) => l.id == id);
  }
}
