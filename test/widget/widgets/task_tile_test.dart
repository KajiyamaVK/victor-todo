// test/widget/widgets/task_tile_test.dart
//
// Widget tests for [TaskTile].
// Provider state is overridden with fakes — no real database is used.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:victor_todo/domain/entities/priority.dart';
import 'package:victor_todo/domain/entities/task.dart';
import 'package:victor_todo/presentation/providers/task_providers.dart';
import 'package:victor_todo/presentation/theme/app_theme.dart';
import 'package:victor_todo/presentation/widgets/task_tile.dart';

import '../../helpers/fake_task_repository.dart';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

/// A test scaffold that places [child] on its own route without a router —
/// used for simpler tile-only tests.
Widget wrapWithProviders(Widget child, FakeTaskRepository fakeRepo) {
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWith((ref) => fakeRepo),
    ],
    child: MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: child),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // Convenience factory for creating a test task.
  Task makeTask({
    String id = 'task-1',
    String title = 'Write tests',
    Priority priority = Priority.medium,
    bool isCompleted = false,
    DateTime? dueDate,
  }) {
    final now = DateTime.now();
    return Task(
      id: id,
      title: title,
      priority: priority,
      isCompleted: isCompleted,
      createdAt: now,
      updatedAt: now,
      dueDate: dueDate,
    );
  }

  group('TaskTile', () {
    testWidgets('renders task title', (tester) async {
      final fakeRepo = FakeTaskRepository();
      final task = makeTask(title: 'My important task');

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      expect(find.text('My important task'), findsOneWidget);
    });

    testWidgets('renders a checkbox unchecked for incomplete task',
        (tester) async {
      final fakeRepo = FakeTaskRepository();
      final task = makeTask(isCompleted: false);

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      // There should be exactly one Checkbox widget.
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('renders a checkbox checked for completed task',
        (tester) async {
      final fakeRepo = FakeTaskRepository();
      final task = makeTask(isCompleted: true);

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('renders PriorityBadge', (tester) async {
      final fakeRepo = FakeTaskRepository();
      final task = makeTask(priority: Priority.urgent);

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      // PriorityBadge displays the label in uppercase (see PriorityBadge._labelFor).
      expect(find.text('URGENT'), findsOneWidget);
    });

    testWidgets('shows due date chip when dueDate is set', (tester) async {
      final fakeRepo = FakeTaskRepository();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final task = makeTask(dueDate: tomorrow);

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      // The due date chip contains a calendar icon.
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('does not show due date chip when dueDate is null',
        (tester) async {
      final fakeRepo = FakeTaskRepository();
      final task = makeTask(dueDate: null);

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      expect(find.byIcon(Icons.calendar_today_outlined), findsNothing);
    });

    testWidgets('completed task title has strikethrough style', (tester) async {
      final fakeRepo = FakeTaskRepository();
      final task = makeTask(title: 'Done task', isCompleted: true);

      await tester.pumpWidget(
        wrapWithProviders(TaskTile(task: task), fakeRepo),
      );

      final text = tester.widget<Text>(
        find.text('Done task'),
      );
      expect(
        text.style?.decoration,
        TextDecoration.lineThrough,
      );
    });
  });
}
