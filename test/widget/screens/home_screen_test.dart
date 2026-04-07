// test/widget/screens/home_screen_test.dart
//
// Widget tests for [HomeScreen].
// Provider overrides replace the real database with fake in-memory repos.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:taskem/domain/entities/priority.dart';
import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/presentation/providers/task_providers.dart';
import 'package:taskem/presentation/screens/home/home_screen.dart';
import 'package:taskem/presentation/theme/app_theme.dart';

import '../../helpers/fake_task_repository.dart';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

/// Creates a GoRouter that renders [HomeScreen] at the root.
GoRouter _makeRouter({required GoRouterWidgetBuilder homeBuilder}) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: homeBuilder,
      ),
      // Stub route so navigation from HomeScreen doesn't throw.
      GoRoute(
        path: '/task',
        builder: (_, __) => const Scaffold(body: Text('Task Detail')),
      ),
      GoRoute(
        path: '/categories',
        builder: (_, __) => const Scaffold(body: Text('Categories')),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const Scaffold(body: Text('Settings')),
      ),
    ],
  );
}

/// Builds a fully overridden [ProviderScope] + [MaterialApp.router] wrapping
/// [HomeScreen], using a [FakeTaskRepository] so no real DB is needed.
Widget _buildTestApp(FakeTaskRepository fakeRepo) {
  final router = _makeRouter(
    homeBuilder: (_, __) => const HomeScreen(),
  );

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

Task _makeTask({required String id, required String title}) {
  final now = DateTime.now();
  return Task(
    id: id,
    title: title,
    priority: Priority.medium,
    isCompleted: false,
    createdAt: now,
    updatedAt: now,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('HomeScreen', () {
    testWidgets('shows AppBar with title "All Tasks"', (tester) async {
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo));
      // Allow async provider to resolve.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('All Tasks'), findsOneWidget);
    });

    testWidgets('shows EmptyState when task list is empty', (tester) async {
      final fakeRepo = FakeTaskRepository(); // no tasks seeded

      await tester.pumpWidget(_buildTestApp(fakeRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // EmptyState renders "No tasks yet".
      expect(find.text('No tasks yet'), findsOneWidget);
    });

    testWidgets('shows task titles when tasks exist', (tester) async {
      final fakeRepo = FakeTaskRepository()
        ..tasks.addAll([
          _makeTask(id: 'a', title: 'Buy groceries'),
          _makeTask(id: 'b', title: 'Walk the dog'),
        ]);

      await tester.pumpWidget(_buildTestApp(fakeRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Buy groceries'), findsOneWidget);
      expect(find.text('Walk the dog'), findsOneWidget);
    });

    testWidgets('shows FloatingActionButton to add a task', (tester) async {
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo));
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('does not show an error state on initial render',
        (tester) async {
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo));
      // The app builds without throwing an error — either loading or data.
      await tester.pump();

      // Verify no unhandled exception text appears.
      expect(find.textContaining('Error loading tasks'), findsNothing);
    });

    testWidgets('data branch wraps ListView in ConstrainedBox(800)',
        (tester) async {
      final fakeRepo = FakeTaskRepository()
        ..tasks.addAll([
          _makeTask(id: 'a', title: 'Test task'),
        ]);

      await tester.pumpWidget(_buildTestApp(fakeRepo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // ConstrainedBox with maxWidth 800 must be present when list has items.
      final boxes =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      expect(
        boxes.any((b) => b.constraints.maxWidth == 800.0),
        isTrue,
        reason:
            'Expected a ConstrainedBox with maxWidth 800 in the data branch',
      );
    });
  });
}
