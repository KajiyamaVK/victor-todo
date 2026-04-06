# Responsive Max-Width Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Cap content width at 800px on web/desktop for `HomeScreen`, `TaskListScreen`, and `TaskDetailScreen`.

**Architecture:** Add `kContentMaxWidth = 800.0` to `AppConstants`. List screens wrap only the `ListView.builder` in their `data` branch with `Align(topCenter)` + `ConstrainedBox`. The form screen wraps its entire `Form` body with `Center` + `ConstrainedBox`. Widget tests assert the constraint is present in the data branch and absent from loading/error branches.

**Tech Stack:** Flutter widgets (`Align`, `Center`, `ConstrainedBox`), `flutter_test` widget tests, `flutter_riverpod` provider overrides.

---

### Task 1: Add `kContentMaxWidth` constant

**Files:**
- Modify: `lib/core/constants/app_constants.dart`

- [ ] **Step 1: Add the constant**

Open `lib/core/constants/app_constants.dart` and add after the last existing constant:

```dart
  /// Maximum width (in logical pixels) for centred content on wide screens.
  /// Applied to list and form screens on web/desktop.
  static const double kContentMaxWidth = 800.0;
```

- [ ] **Step 2: Verify analyze passes**

```bash
dart analyze lib/core/constants/app_constants.dart
```
Expected: no issues.

- [ ] **Step 3: Commit**

```bash
git add lib/core/constants/app_constants.dart
git commit -m "feat: add kContentMaxWidth constant to AppConstants"
```

---

### Task 2: Constrain HomeScreen list

**Files:**
- Modify: `lib/presentation/screens/home/home_screen.dart`
- Test: `test/widget/screens/home_screen_test.dart`

- [ ] **Step 1: Write the failing test**

Open `test/widget/screens/home_screen_test.dart`. Add this test inside the existing `group('HomeScreen', () { ... })` block:

```dart
testWidgets('data branch wraps ListView in ConstrainedBox(800)', (tester) async {
  final fakeRepo = FakeTaskRepository()
    ..tasks.addAll([
      _makeTask(id: 'a', title: 'Test task'),
    ]);

  await tester.pumpWidget(_buildTestApp(fakeRepo));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));

  // ConstrainedBox with maxWidth 800 must be present when list has items.
  final boxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
  expect(
    boxes.any((b) => b.constraints.maxWidth == 800.0),
    isTrue,
    reason: 'Expected a ConstrainedBox with maxWidth 800 in the data branch',
  );
});
```

- [ ] **Step 2: Run the test and confirm red**

```bash
flutter test test/widget/screens/home_screen_test.dart --name "data branch wraps ListView in ConstrainedBox"
```
Expected: FAIL — no `ConstrainedBox` with `maxWidth 800` found.

- [ ] **Step 3: Implement the constraint**

In `lib/presentation/screens/home/home_screen.dart`, replace the `data` branch's return value:

```dart
// Before:
data: (tasks) {
  if (tasks.isEmpty) {
    return EmptyState(
      message: 'No tasks yet',
      ctaLabel: 'Add your first task',
      onCtaTap: () => context.push(RouteConstants.taskDetail),
    );
  }
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return TaskTile(task: tasks[index]);
    },
  );
},

// After:
data: (tasks) {
  if (tasks.isEmpty) {
    return EmptyState(
      message: 'No tasks yet',
      ctaLabel: 'Add your first task',
      onCtaTap: () => context.push(RouteConstants.taskDetail),
    );
  }
  // Constrain list width on wide screens (web/desktop).
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConstants.kContentMaxWidth,
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(task: tasks[index]);
        },
      ),
    ),
  );
},
```

Add import at top of file if not already present:
```dart
import 'package:taskem/core/constants/app_constants.dart';
```

- [ ] **Step 4: Run test and confirm green**

```bash
flutter test test/widget/screens/home_screen_test.dart
```
Expected: all tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/screens/home/home_screen.dart \
        test/widget/screens/home_screen_test.dart
git commit -m "feat: constrain HomeScreen list to 800px max width"
```

---

### Task 3: Constrain TaskListScreen list

**Files:**
- Modify: `lib/presentation/screens/task_list/task_list_screen.dart`
- Test: `test/widget/screens/task_list_screen_test.dart` (new file)

- [ ] **Step 1: Write the failing test**

Create `test/widget/screens/task_list_screen_test.dart`:

```dart
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

Widget _buildTestApp(FakeTaskRepository fakeRepo, String listId) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => TaskListScreen(listId: listId),
      ),
      GoRoute(
        path: '/task',
        builder: (_, __) => const Scaffold(body: Text('Task Detail')),
      ),
    ],
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

Task _makeTask({required String id, required String title, String? listId}) {
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

void main() {
  group('TaskListScreen', () {
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
        boxes.any((b) => b.constraints.maxWidth == AppConstants.kContentMaxWidth),
        isTrue,
        reason: 'Expected a ConstrainedBox with maxWidth 800 in the data branch',
      );
    });

    testWidgets('shows EmptyState when list is empty', (tester) async {
      final fakeRepo = FakeTaskRepository();

      await tester.pumpWidget(_buildTestApp(fakeRepo, 'list-1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No tasks in this list'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run and confirm red**

```bash
flutter test test/widget/screens/task_list_screen_test.dart --name "data branch wraps ListView"
```
Expected: FAIL.

- [ ] **Step 3: Implement the constraint**

In `lib/presentation/screens/task_list/task_list_screen.dart`, replace the `data` branch:

```dart
// Before:
data: (tasks) {
  if (tasks.isEmpty) {
    return EmptyState(
      message: 'No tasks in this list',
      ctaLabel: 'Add a task',
      onCtaTap: () => context.push(RouteConstants.taskDetail),
    );
  }
  return ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return TaskTile(task: tasks[index]);
    },
  );
},

// After:
data: (tasks) {
  if (tasks.isEmpty) {
    return EmptyState(
      message: 'No tasks in this list',
      ctaLabel: 'Add a task',
      onCtaTap: () => context.push(RouteConstants.taskDetail),
    );
  }
  // Constrain list width on wide screens (web/desktop).
  return Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConstants.kContentMaxWidth,
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(task: tasks[index]);
        },
      ),
    ),
  );
},
```

Add import at top of file if not already present:
```dart
import 'package:taskem/core/constants/app_constants.dart';
```

- [ ] **Step 4: Run tests and confirm green**

```bash
flutter test test/widget/screens/task_list_screen_test.dart
```
Expected: all tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/screens/task_list/task_list_screen.dart \
        test/widget/screens/task_list_screen_test.dart
git commit -m "feat: constrain TaskListScreen list to 800px max width"
```

---

### Task 4: Constrain TaskDetailScreen form

**Files:**
- Modify: `lib/presentation/screens/task_detail/task_detail_screen.dart`
- Test: `test/widget/screens/task_detail_screen_test.dart` (new file)

- [ ] **Step 1: Write the failing test**

Create `test/widget/screens/task_detail_screen_test.dart`:

```dart
// test/widget/screens/task_detail_screen_test.dart
//
// Widget tests for [TaskDetailScreen].

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:taskem/core/constants/app_constants.dart';
import 'package:taskem/presentation/providers/category_providers.dart';
import 'package:taskem/presentation/providers/tag_providers.dart';
import 'package:taskem/presentation/providers/task_providers.dart';
import 'package:taskem/presentation/screens/task_detail/task_detail_screen.dart';
import 'package:taskem/presentation/theme/app_theme.dart';

import '../../helpers/fake_category_repository.dart';
import '../../helpers/fake_tag_repository.dart';
import '../../helpers/fake_task_repository.dart';

Widget _buildTestApp() {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const TaskDetailScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWith((ref) => FakeTaskRepository()),
      categoryRepositoryProvider.overrideWith((ref) => FakeCategoryRepository()),
      tagRepositoryProvider.overrideWith((ref) => FakeTagRepository()),
    ],
    child: MaterialApp.router(
      theme: AppTheme.dark,
      routerConfig: router,
    ),
  );
}

void main() {
  group('TaskDetailScreen', () {
    testWidgets('form body is wrapped in ConstrainedBox(800)', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final boxes =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      expect(
        boxes.any((b) => b.constraints.maxWidth == AppConstants.kContentMaxWidth),
        isTrue,
        reason: 'Expected a ConstrainedBox with maxWidth 800 wrapping the form',
      );
    });

    testWidgets('shows Title field', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Title *'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Check what fake repositories expose**

Open `test/helpers/fake_category_repository.dart` and `test/helpers/fake_tag_repository.dart` and confirm the class names. If the provider names differ from `categoryRepositoryProvider` / `tagRepositoryProvider`, adjust the overrides in the test above to match.

- [ ] **Step 3: Run and confirm red**

```bash
flutter test test/widget/screens/task_detail_screen_test.dart --name "form body is wrapped"
```
Expected: FAIL.

- [ ] **Step 4: Implement the constraint**

In `lib/presentation/screens/task_detail/task_detail_screen.dart`, replace the `body:` of the `Scaffold`:

```dart
// Before:
body: Form(
  key: _formKey,
  child: ListView(
    padding: const EdgeInsets.all(16),
    children: [ ... ],
  ),
),

// After:
body: Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: AppConstants.kContentMaxWidth,
    ),
    child: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [ ... ],
      ),
    ),
  ),
),
```

Keep the `children: [ ... ]` contents exactly as they are — only the wrapping changes.

Add import at top of file if not already present:
```dart
import 'package:taskem/core/constants/app_constants.dart';
```

- [ ] **Step 5: Run tests and confirm green**

```bash
flutter test test/widget/screens/task_detail_screen_test.dart
```
Expected: all tests PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/screens/task_detail/task_detail_screen.dart \
        test/widget/screens/task_detail_screen_test.dart
git commit -m "feat: constrain TaskDetailScreen form to 800px max width"
```

---

### Task 5: Full test suite + format pass

**Files:** none (verification only)

- [ ] **Step 1: Run dart format**

```bash
dart format lib/ test/
```

- [ ] **Step 2: Run dart analyze**

```bash
dart analyze
```
Expected: no issues.

- [ ] **Step 3: Run full test suite**

```bash
flutter test
```
Expected: all tests PASS.

- [ ] **Step 4: Commit format fixes if any**

```bash
git add -u
git commit -m "style: dart format after max-width feature"
```
(Skip this step if no files changed.)
