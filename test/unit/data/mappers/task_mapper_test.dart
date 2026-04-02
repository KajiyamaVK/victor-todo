// test/unit/data/mappers/task_mapper_test.dart
//
// Tests for TaskMapper — verifies correct conversion between drift data
// classes and domain entities.

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

// Alias drift-generated types to avoid name collisions with domain entities.
import 'package:victor_todo/data/datasources/database/app_database.dart' as db
    show Task;
import 'package:victor_todo/data/mappers/task_mapper.dart';
import 'package:victor_todo/domain/entities/priority.dart';
import 'package:victor_todo/domain/entities/task.dart' as domain show Task;

void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  db.Task makeDbTask({
    String id = 'task-1',
    String title = 'Buy milk',
    String? description,
    int? dueDate,
    String priority = 'medium',
    bool isCompleted = false,
    int? completedAt,
    String? categoryId,
    String? taskListId,
    int? reminderTime,
    int createdAt = 1000000,
    int updatedAt = 2000000,
  }) {
    return db.Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      isCompleted: isCompleted,
      completedAt: completedAt,
      categoryId: categoryId,
      taskListId: taskListId,
      reminderTime: reminderTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  domain.Task makeDomainTask({
    String id = 'task-1',
    String title = 'Buy milk',
    Priority priority = Priority.medium,
    bool isCompleted = false,
    List<String> tagIds = const [],
    DateTime? dueDate,
    String? categoryId,
    String? taskListId,
  }) {
    final now = DateTime.fromMillisecondsSinceEpoch(1000000);
    return domain.Task(
      id: id,
      title: title,
      priority: priority,
      isCompleted: isCompleted,
      createdAt: now,
      updatedAt: now,
      tagIds: tagIds,
      dueDate: dueDate,
      categoryId: categoryId,
      taskListId: taskListId,
    );
  }

  group('TaskMapper.toDomain', () {
    test('maps basic fields correctly', () {
      final data = makeDbTask();
      final task = TaskMapper.toDomain(data, []);

      expect(task.id, 'task-1');
      expect(task.title, 'Buy milk');
      expect(task.priority, Priority.medium);
      expect(task.isCompleted, false);
      expect(task.tagIds, isEmpty);
    });

    test('maps dueDate from Unix ms timestamp', () {
      final due = DateTime(2025, 12, 31).millisecondsSinceEpoch;
      final data = makeDbTask(dueDate: due);
      final task = TaskMapper.toDomain(data, []);

      expect(task.dueDate?.millisecondsSinceEpoch, due);
    });

    test('maps null dueDate to null', () {
      final task = TaskMapper.toDomain(makeDbTask(dueDate: null), []);

      expect(task.dueDate, isNull);
    });

    test('maps priority strings correctly', () {
      expect(
        TaskMapper.toDomain(makeDbTask(priority: 'low'), []).priority,
        Priority.low,
      );
      expect(
        TaskMapper.toDomain(makeDbTask(priority: 'high'), []).priority,
        Priority.high,
      );
      expect(
        TaskMapper.toDomain(makeDbTask(priority: 'urgent'), []).priority,
        Priority.urgent,
      );
    });

    test('unknown priority defaults to medium', () {
      final task = TaskMapper.toDomain(makeDbTask(priority: 'UNKNOWN'), []);

      expect(task.priority, Priority.medium);
    });

    test('maps tagIds list', () {
      final task = TaskMapper.toDomain(makeDbTask(), ['t1', 't2', 't3']);

      expect(task.tagIds, ['t1', 't2', 't3']);
    });
  });

  group('TaskMapper.toCompanion', () {
    test('maps basic fields correctly', () {
      final task = makeDomainTask();
      final companion = TaskMapper.toCompanion(task);

      expect(companion.id, const Value('task-1'));
      expect(companion.title, const Value('Buy milk'));
      expect(companion.priority, const Value('medium'));
    });

    test('maps dueDate to Unix ms timestamp', () {
      final due = DateTime(2025, 12, 31);
      final task = makeDomainTask(dueDate: due);
      final companion = TaskMapper.toCompanion(task);

      expect(companion.dueDate.value, due.millisecondsSinceEpoch);
    });

    test('maps null dueDate to Value(null)', () {
      final task = makeDomainTask(dueDate: null);
      final companion = TaskMapper.toCompanion(task);

      expect(companion.dueDate.value, isNull);
    });

    test('maps priority enum to string', () {
      expect(
        TaskMapper.toCompanion(
          makeDomainTask(priority: Priority.urgent),
        ).priority,
        const Value('urgent'),
      );
      expect(
        TaskMapper.toCompanion(
          makeDomainTask(priority: Priority.low),
        ).priority,
        const Value('low'),
      );
    });
  });
}
