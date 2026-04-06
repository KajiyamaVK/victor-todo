// test/unit/domain/entities/task_list_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:taskem/domain/entities/task_list.dart';

void main() {
  group('TaskList entity', () {
    test('can be created with required fields', () {
      final now = DateTime(2025, 1, 1);
      final list = TaskList(id: 'list-1', name: 'Shopping', createdAt: now);

      expect(list.id, 'list-1');
      expect(list.name, 'Shopping');
      expect(list.createdAt, now);
      expect(list.description, isNull);
    });

    test('copyWith creates a new instance with updated fields', () {
      final now = DateTime(2025, 1, 1);
      final list = TaskList(id: 'list-1', name: 'Shopping', createdAt: now);
      final updated = list.copyWith(name: 'Groceries');

      expect(list.name, 'Shopping'); // Original unchanged.
      expect(updated.name, 'Groceries');
      expect(updated.id, 'list-1');
    });

    test('copyWith can set description', () {
      final now = DateTime(2025, 1, 1);
      final list = TaskList(id: 'list-1', name: 'Work', createdAt: now);
      final updated = list.copyWith(description: 'Work related tasks');

      expect(updated.description, 'Work related tasks');
    });

    test('equality is based on id only', () {
      final now = DateTime(2025, 1, 1);
      final list1 = TaskList(id: 'same-id', name: 'Shopping', createdAt: now);
      final list2 = TaskList(id: 'same-id', name: 'Groceries', createdAt: now);
      final list3 = TaskList(id: 'other-id', name: 'Shopping', createdAt: now);

      expect(list1, equals(list2));
      expect(list1, isNot(equals(list3)));
    });
  });
}
