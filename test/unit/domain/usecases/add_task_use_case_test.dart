// test/unit/domain/usecases/add_task_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:victor_todo/domain/entities/priority.dart';
import 'package:victor_todo/domain/entities/task.dart';
import 'package:victor_todo/domain/usecases/task/add_task_use_case.dart';
import '../../../helpers/fake_task_repository.dart';

void main() {
  late FakeTaskRepository repository;
  late AddTaskUseCase useCase;

  setUp(() {
    repository = FakeTaskRepository();
    useCase = AddTaskUseCase(repository);
  });

  Task makeTask({
    String id = 'task-1',
    String title = 'My Task',
    DateTime? dueDate,
  }) {
    final now = DateTime.now();
    return Task(
      id: id,
      title: title,
      priority: Priority.medium,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
      dueDate: dueDate,
    );
  }

  group('AddTaskUseCase', () {
    test('adds a task to the repository', () async {
      final task = makeTask();

      await useCase.execute(task);

      expect(repository.tasks, hasLength(1));
      expect(repository.tasks.first.id, task.id);
    });

    test('throws ArgumentError when title is empty', () async {
      final task = makeTask(title: '');

      expect(() => useCase.execute(task), throwsArgumentError);
    });

    test('throws ArgumentError when title is only whitespace', () async {
      final task = makeTask(title: '   ');

      expect(() => useCase.execute(task), throwsArgumentError);
    });

    test('throws ArgumentError when dueDate is in the past', () async {
      final past = DateTime.now().subtract(const Duration(days: 1));
      final task = makeTask(dueDate: past);

      expect(() => useCase.execute(task), throwsArgumentError);
    });

    test('accepts a task with no dueDate', () async {
      final task = makeTask(dueDate: null);

      await expectLater(useCase.execute(task), completes);
      expect(repository.tasks, hasLength(1));
    });

    test('accepts a task with a future dueDate', () async {
      final future = DateTime.now().add(const Duration(days: 1));
      final task = makeTask(dueDate: future);

      await expectLater(useCase.execute(task), completes);
      expect(repository.tasks, hasLength(1));
    });
  });
}
