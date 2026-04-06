// test/unit/domain/usecases/complete_task_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:taskem/domain/entities/priority.dart';
import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/domain/usecases/task/complete_task_use_case.dart';
import '../../../helpers/fake_task_repository.dart';

/// Fake NotificationService used solely for testing CompleteTaskUseCase.
/// Records the cancel calls for assertion.
class FakeNotificationService {
  final List<int> cancelledIds = [];

  Future<void> cancelReminder(int notificationId) async {
    cancelledIds.add(notificationId);
  }
}

void main() {
  late FakeTaskRepository repository;
  late FakeNotificationService notificationService;
  late CompleteTaskUseCase useCase;

  setUp(() {
    repository = FakeTaskRepository();
    notificationService = FakeNotificationService();
    useCase = CompleteTaskUseCase(
      repository,
      notificationService.cancelReminder,
    );
  });

  Task seedTask({bool isCompleted = false}) {
    final now = DateTime.now();
    final task = Task(
      id: 'task-1',
      title: 'Buy milk',
      priority: Priority.low,
      isCompleted: isCompleted,
      createdAt: now,
      updatedAt: now,
    );
    repository.tasks.add(task);
    return task;
  }

  group('CompleteTaskUseCase', () {
    test('marks task as completed and sets completedAt', () async {
      seedTask();

      await useCase.execute('task-1');

      final updated = repository.tasks.first;
      expect(updated.isCompleted, isTrue);
      expect(updated.completedAt, isNotNull);
    });

    test('throws StateError when task is not found', () async {
      await expectLater(
        useCase.execute('non-existent'),
        throwsA(isA<StateError>()),
      );
    });

    test('calls cancelReminder with the task notification id', () async {
      seedTask();

      await useCase.execute('task-1');

      // Notification id is derived from task id hashCode.
      expect(notificationService.cancelledIds, hasLength(1));
    });

    test('does nothing if the task is already completed', () async {
      seedTask(isCompleted: true);

      // Should not throw even if already completed.
      await expectLater(useCase.execute('task-1'), completes);
    });
  });
}
