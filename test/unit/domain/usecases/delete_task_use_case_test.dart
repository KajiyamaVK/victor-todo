// test/unit/domain/usecases/delete_task_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:victor_todo/domain/entities/priority.dart';
import 'package:victor_todo/domain/entities/task.dart';
import 'package:victor_todo/domain/usecases/task/delete_task_use_case.dart';
import '../../../helpers/fake_task_repository.dart';

/// Fake cancel function for notifications.
class FakeNotificationService {
  final List<int> cancelledIds = [];

  Future<void> cancelReminder(int notificationId) async {
    cancelledIds.add(notificationId);
  }
}

void main() {
  late FakeTaskRepository repository;
  late FakeNotificationService notificationService;
  late DeleteTaskUseCase useCase;

  setUp(() {
    repository = FakeTaskRepository();
    notificationService = FakeNotificationService();
    useCase = DeleteTaskUseCase(
      repository,
      notificationService.cancelReminder,
    );
  });

  group('DeleteTaskUseCase', () {
    test('removes the task from the repository', () async {
      final now = DateTime.now();
      repository.tasks.add(
        Task(
          id: 'task-1',
          title: 'Task to delete',
          priority: Priority.low,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      );

      await useCase.execute('task-1');

      expect(repository.tasks, isEmpty);
    });

    test('cancels the notification for the deleted task', () async {
      final now = DateTime.now();
      repository.tasks.add(
        Task(
          id: 'task-1',
          title: 'Task to delete',
          priority: Priority.low,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      );

      await useCase.execute('task-1');

      expect(notificationService.cancelledIds, hasLength(1));
    });

    test('succeeds even if task does not exist (no-op)', () async {
      await expectLater(useCase.execute('non-existent'), completes);
    });
  });
}
