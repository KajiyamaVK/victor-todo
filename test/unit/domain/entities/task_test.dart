// test/unit/domain/entities/task_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:victor_todo/domain/entities/priority.dart';
import 'package:victor_todo/domain/entities/task.dart';

void main() {
  // Helper to create a minimal valid task.
  Task makeTask({
    String id = 'task-1',
    String title = 'Test Task',
    Priority priority = Priority.medium,
    bool isCompleted = false,
    List<String> tagIds = const [],
  }) {
    final now = DateTime(2025, 1, 1);
    return Task(
      id: id,
      title: title,
      priority: priority,
      isCompleted: isCompleted,
      createdAt: now,
      updatedAt: now,
      tagIds: tagIds,
    );
  }

  group('Task entity', () {
    test('can be created with required fields', () {
      final task = makeTask();

      expect(task.id, 'task-1');
      expect(task.title, 'Test Task');
      expect(task.priority, Priority.medium);
      expect(task.isCompleted, false);
      expect(task.tagIds, isEmpty);
    });

    test('optional fields default to null', () {
      final task = makeTask();

      expect(task.description, isNull);
      expect(task.dueDate, isNull);
      expect(task.reminderAt, isNull);
      expect(task.completedAt, isNull);
      expect(task.categoryId, isNull);
      expect(task.taskListId, isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final task = makeTask();
      final updated = task.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );

      // Original is unchanged (immutable).
      expect(task.title, 'Test Task');
      expect(task.isCompleted, false);

      // Updated instance has new values.
      expect(updated.title, 'Updated Title');
      expect(updated.isCompleted, true);
      expect(updated.id, task.id); // id unchanged
    });

    test('copyWith preserves unchanged fields', () {
      final now = DateTime(2025, 6, 1);
      final task = Task(
        id: 'abc',
        title: 'My Task',
        priority: Priority.high,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
        description: 'Some description',
        categoryId: 'cat-1',
        tagIds: ['tag-1', 'tag-2'],
      );

      final updated = task.copyWith(title: 'New Title');

      expect(updated.description, 'Some description');
      expect(updated.categoryId, 'cat-1');
      expect(updated.tagIds, ['tag-1', 'tag-2']);
      expect(updated.priority, Priority.high);
    });

    test('equality is based on id only', () {
      final now = DateTime(2025, 1, 1);
      final task1 = Task(
        id: 'same-id',
        title: 'Task One',
        priority: Priority.low,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );
      final task2 = Task(
        id: 'same-id',
        title: 'Task Two',
        priority: Priority.urgent,
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );
      final task3 = Task(
        id: 'different-id',
        title: 'Task One',
        priority: Priority.low,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('hashCode is based on id', () {
      final now = DateTime(2025, 1, 1);
      final task1 = Task(
        id: 'my-id',
        title: 'Task 1',
        priority: Priority.low,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );
      final task2 = Task(
        id: 'my-id',
        title: 'Task 2',
        priority: Priority.high,
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(task1.hashCode, equals(task2.hashCode));
    });

    test('can store dueDate', () {
      final due = DateTime(2025, 12, 31);
      final task = makeTask().copyWith(dueDate: due);

      expect(task.dueDate, due);
    });

    test('can store tagIds', () {
      final task = makeTask(tagIds: ['tag-1', 'tag-2', 'tag-3']);

      expect(task.tagIds, hasLength(3));
      expect(task.tagIds, contains('tag-2'));
    });
  });
}
