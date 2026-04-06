// test/helpers/fake_task_repository.dart
//
// In-memory fake implementation of [TaskRepository] for use in unit tests.
// No database, no drift — just a plain list.

import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/domain/repositories/task_repository.dart';

/// In-memory fake implementation of [TaskRepository].
///
/// Stores tasks in a plain [List]. Not thread-safe, not persistent.
/// Use in unit tests to verify use-case behaviour without a database.
class FakeTaskRepository implements TaskRepository {
  /// The backing store — tests can inspect or seed this directly.
  final List<Task> tasks = [];

  @override
  Future<List<Task>> getAllTasks() async {
    // Sort by due date ascending, nulls last — mirrors the real implementation.
    final sorted = List<Task>.from(tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1; // nulls last
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }

  @override
  Future<List<Task>> getTasksByList(String listId) async {
    return tasks.where((t) => t.taskListId == listId).toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addTask(Task task) async {
    tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    tasks.removeWhere((t) => t.id == id);
  }
}
