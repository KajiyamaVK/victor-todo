// test/unit/data/daos/task_dao_test.dart
//
// Integration tests for TaskDao using an in-memory SQLite database.
// These tests verify DAO CRUD operations without hitting the filesystem.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:victor_todo/data/datasources/database/app_database.dart';
import '../../../helpers/sqlite_test_helper.dart';

void main() {
  setUpAll(initSqliteForTests);

  late AppDatabase db;

  setUp(() {
    // Each test gets a fresh in-memory database — no state bleed between tests.
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('TaskDao', () {
    // Helper: create a minimal TasksCompanion for testing.
    TasksCompanion makeTask({
      String id = 'task-1',
      String title = 'Test Task',
      String priority = 'medium',
      bool isCompleted = false,
      int? dueDate,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return TasksCompanion.insert(
        id: id,
        title: title,
        priority: Value(priority),
        isCompleted: Value(isCompleted),
        createdAt: now,
        updatedAt: now,
        dueDate: Value(dueDate),
      );
    }

    test('insertTask persists a new task row', () async {
      await db.taskDao.insertTask(makeTask());

      final tasks = await db.taskDao.getAllTasks();
      expect(tasks, hasLength(1));
      expect(tasks.first.id, 'task-1');
      expect(tasks.first.title, 'Test Task');
    });

    test('getAllTasks returns rows ordered by dueDate ASC, nulls last',
        () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final tomorrow = now + const Duration(days: 1).inMilliseconds;
      final dayAfterTomorrow = now + const Duration(days: 2).inMilliseconds;

      // Insert tasks in reverse date order with one null date.
      await db.taskDao.insertTask(
        makeTask(id: 'c', title: 'C', dueDate: dayAfterTomorrow),
      );
      await db.taskDao.insertTask(
        makeTask(id: 'b', title: 'B', dueDate: tomorrow),
      );
      await db.taskDao.insertTask(
        makeTask(id: 'a', title: 'A', dueDate: null),
      );

      final tasks = await db.taskDao.getAllTasks();

      expect(tasks, hasLength(3));
      // Null last — 'a' should be last.
      expect(tasks[0].id, 'b'); // earliest date first
      expect(tasks[1].id, 'c');
      expect(tasks[2].id, 'a'); // null date last
    });

    test('getTaskById returns the correct task', () async {
      await db.taskDao.insertTask(makeTask(id: 'task-x', title: 'X'));
      await db.taskDao.insertTask(makeTask(id: 'task-y', title: 'Y'));

      final task = await db.taskDao.getTaskById('task-x');

      expect(task, isNotNull);
      expect(task!.id, 'task-x');
      expect(task.title, 'X');
    });

    test('getTaskById returns null when task does not exist', () async {
      final task = await db.taskDao.getTaskById('nonexistent');
      expect(task, isNull);
    });

    test('updateTask modifies an existing task row', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.taskDao.insertTask(makeTask(id: 'task-1', title: 'Original'));

      await db.taskDao.updateTask(
        TasksCompanion(
          id: const Value('task-1'),
          title: const Value('Updated Title'),
          updatedAt: Value(now),
        ),
      );

      final task = await db.taskDao.getTaskById('task-1');
      expect(task!.title, 'Updated Title');
    });

    test('deleteTask removes the task row', () async {
      await db.taskDao.insertTask(makeTask(id: 'to-delete'));
      await db.taskDao.insertTask(makeTask(id: 'to-keep'));

      await db.taskDao.deleteTask('to-delete');

      final tasks = await db.taskDao.getAllTasks();
      expect(tasks, hasLength(1));
      expect(tasks.first.id, 'to-keep');
    });

    test('getTasksByList returns only tasks for that list', () async {
      // Requires a TaskList to exist for FK constraint.
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.taskListDao.insertTaskList(
        TaskListsCompanion.insert(
          id: 'list-1',
          name: 'My List',
          createdAt: now,
        ),
      );

      await db.taskDao.insertTask(makeTask(id: 't1', title: 'In list'));
      // Manually set the listId via update since the helper doesn't expose it.
      await db.taskDao.updateTask(
        TasksCompanion(
          id: const Value('t1'),
          taskListId: const Value('list-1'),
          updatedAt: Value(now),
        ),
      );
      await db.taskDao.insertTask(makeTask(id: 't2', title: 'No list'));

      final inList = await db.taskDao.getTasksByList('list-1');
      expect(inList, hasLength(1));
      expect(inList.first.id, 't1');
    });
  });

  group('TaskDao — TaskTags', () {
    // Helper to insert a tag for FK satisfaction.
    Future<void> insertTag(String id, String name) async {
      await db.tagDao.insertTag(TagsCompanion.insert(id: id, name: name));
    }

    test('insertTaskTag creates an association row', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 'task-1',
          title: 'Tagged Task',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await insertTag('tag-1', 'flutter');

      await db.taskDao.insertTaskTag(
        TaskTagsCompanion.insert(taskId: 'task-1', tagId: 'tag-1'),
      );

      final tagIds = await db.taskDao.getTagIdsForTask('task-1');
      expect(tagIds, ['tag-1']);
    });

    test('deleteTagsForTask removes all tag associations for a task', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 'task-1',
          title: 'Tagged Task',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await insertTag('tag-1', 'flutter');
      await insertTag('tag-2', 'dart');

      await db.taskDao.insertTaskTag(
        TaskTagsCompanion.insert(taskId: 'task-1', tagId: 'tag-1'),
      );
      await db.taskDao.insertTaskTag(
        TaskTagsCompanion.insert(taskId: 'task-1', tagId: 'tag-2'),
      );

      await db.taskDao.deleteTagsForTask('task-1');

      final tagIds = await db.taskDao.getTagIdsForTask('task-1');
      expect(tagIds, isEmpty);
    });

    test('deleting a task cascades to task_tags rows', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.taskDao.insertTask(
        TasksCompanion.insert(
          id: 'task-cascade',
          title: 'Cascade Task',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await insertTag('tag-x', 'cascade-test');
      await db.taskDao.insertTaskTag(
        TaskTagsCompanion.insert(taskId: 'task-cascade', tagId: 'tag-x'),
      );

      // Delete the task — the TaskTags row should cascade-delete.
      await db.taskDao.deleteTask('task-cascade');

      // Tag row still exists; only the join row is gone.
      final tagIds = await db.taskDao.getTagIdsForTask('task-cascade');
      expect(tagIds, isEmpty);
    });
  });
}
