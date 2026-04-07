// test/widget/screens/task_list_screen_test.dart
//
// Widget tests for [TaskListScreen].

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:taskem/core/constants/app_constants.dart';
import 'package:taskem/domain/entities/priority.dart';
import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/presentation/providers/task_providers.dart';
import 'package:taskem/presentation/screens/task_list/task_list_screen.dart';
import 'package:taskem/presentation/theme/app_theme.dart';

import '../../helpers/fake_task_repository.dart';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

/// Creates a GoRouter that renders [TaskListScreen] at the root with a given
/// [listId].
GoRouter _makeRouter({required String listId}) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => TaskListScreen(listId: listId),
      ),
      // Stub route so navigation from TaskListScreen doesn't throw.
      GoRoute(
        path: '/task',
        builder: (_, __) => const Scaffold(body: Text('Task Detail')),
      ),
    ],
  );
}

/// Builds a fully overridden [ProviderScope] + [MaterialApp.router] wrapping
/// [TaskListScreen], using a [FakeTaskRepository] so no real DB is needed.
Widget _buildTestApp(FakeTaskRepository fakeRepo, String listId) {
  final router = _makeRouter(listId: listId);

  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWith((ref) => fakeRepo),
    ],
    child: MaterialApp.router(
      theme: AppTheme.dark,
      routerConfig: router,
    ),
  );
}

// ---------------------------------------------------------------------------
// Task factory
// ---------------------------------------------------------------------------

/// Creates a task for testing. Allows specifying a [listId] to associate
/// the task with a particular named list.
Task _makeTask({
  required String id,
  required String title,
  String? listId,
}) {
  final now = DateTime.now();
  return Task(
    id: id,
    title: title,
    priority: Priority.medium,
    isCompleted: false,
    createdAt: now,
    updatedAt: now,
    taskListId: listId,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TaskListScreen', () {
    testWidgets('shows AppBar with title "Task List"', (tester) async {
      const listId = 'list-1';
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo, listId));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Task List'), findsOneWidget);
    });

    testWidgets('shows EmptyState when list is empty', (tester) async {
      const listId = 'list-1';
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo, listId));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No tasks in this list'), findsOneWidget);
    });

    testWidgets('shows task titles when tasks exist in the list',
        (tester) async {
      const listId = 'list-1';
      final fakeRepo = FakeTaskRepository()
        ..tasks.addAll([
          _makeTask(id: 'a', title: 'Task A', listId: listId),
          _makeTask(id: 'b', title: 'Task B', listId: listId),
        ]);

      await tester.pumpWidget(_buildTestApp(fakeRepo, listId));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Task A'), findsOneWidget);
      expect(find.text('Task B'), findsOneWidget);
    });

    testWidgets('filters tasks to only show the specified list',
        (tester) async {
      const listId = 'list-1';
      final fakeRepo = FakeTaskRepository()
        ..tasks.addAll([
          _makeTask(id: 'a', title: 'List 1 Task', listId: 'list-1'),
          _makeTask(id: 'b', title: 'List 2 Task', listId: 'list-2'),
        ]);

      await tester.pumpWidget(_buildTestApp(fakeRepo, listId));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('List 1 Task'), findsOneWidget);
      expect(find.text('List 2 Task'), findsNothing);
    });

    testWidgets('shows FloatingActionButton to add a task', (tester) async {
      const listId = 'list-1';
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo, listId));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('data branch wraps ListView in ConstrainedBox(800)',
        (tester) async {
      const listId = 'list-1';
      final fakeRepo = FakeTaskRepository()
        ..tasks.add(_makeTask(id: 'a', title: 'Task A', listId: listId));

      await tester.pumpWidget(_buildTestApp(fakeRepo, listId));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final boxes =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      expect(
        boxes.any(
            (b) => b.constraints.maxWidth == AppConstants.kContentMaxWidth),
        isTrue,
        reason:
            'Expected a ConstrainedBox with maxWidth 800 in the data branch',
      );
    });
  });
}
