# State Management

## Overview: Riverpod

All state management uses **Riverpod** (`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`).

Providers are the single source of truth for:
- Async data (task lists, categories, tags)
- Use case instances (injected with repository dependencies)
- UI state (selected list, filters, form state)

---

## Provider Types in Use

| Provider type | Use case |
|---|---|
| `Provider<T>` | Synchronous, non-changing singletons (AppDatabase, repositories, use cases) |
| `FutureProvider<T>` / `AsyncNotifierProvider<T>` | Async data that loads once and can be refreshed |
| `NotifierProvider<T, S>` | Mutable state with methods (e.g., task list with add/remove/complete) |
| `AsyncNotifierProvider<T, S>` | Async mutable state |

---

## Dependency Chain

```
databaseProvider (Provider<AppDatabase>)
  └─ taskDaoProvider (Provider<TaskDao>)
      └─ taskRepositoryProvider (Provider<TaskRepository>)
          └─ addTaskUseCaseProvider (Provider<AddTaskUseCase>)
          └─ getTasksUseCaseProvider (Provider<GetTasksUseCase>)
              └─ taskListProvider (AsyncNotifierProvider<TaskListNotifier, List<Task>>)
```

Each step depends only on the step above it via constructor injection.

---

## Provider Definitions

### Singleton providers (repositories, use cases)

```dart
// lib/presentation/providers/database_provider.dart

/// Provides the single AppDatabase instance for the app.
/// Uses NativeDatabase for the production path (SQLite via FFI).
@Riverpod(keepAlive: true)
AppDatabase database(DatabaseRef ref) {
  // Closed in the override in tests; never closed in production
  // (app lifetime == database lifetime)
  return AppDatabase(NativeDatabase.createInBackground(
    File('taskem.db'),
  ));
}

// lib/presentation/providers/task_providers.dart

@riverpod
TaskRepository taskRepository(TaskRepositoryRef ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepositoryImpl(db.taskDao);
}

@riverpod
AddTaskUseCase addTaskUseCase(AddTaskUseCaseRef ref) {
  return AddTaskUseCase(ref.watch(taskRepositoryProvider));
}
```

### Async state (task list)

```dart
/// Manages the list of tasks displayed on the home screen.
///
/// Reload triggered by calling [ref.invalidate(taskListProvider)] after
/// any mutation (add, delete, complete).
@riverpod
class TaskListNotifier extends _$TaskListNotifier {
  @override
  Future<List<Task>> build() async {
    return ref.watch(getTasksUseCaseProvider).execute();
  }

  Future<void> addTask(Task task) async {
    await ref.read(addTaskUseCaseProvider).execute(task);
    ref.invalidateSelf();  // Re-fetch after mutation
  }

  Future<void> completeTask(String id) async {
    await ref.read(completeTaskUseCaseProvider).execute(id);
    ref.invalidateSelf();
  }

  Future<void> deleteTask(String id) async {
    await ref.read(deleteTaskUseCaseProvider).execute(id);
    ref.invalidateSelf();
  }
}
```

---

## Widget Integration

Screens extend `ConsumerWidget` (or `ConsumerStatefulWidget` when local state is also needed):

```dart
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the async task list
    final tasksAsync = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Tasks')),
      body: tasksAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, _) => Text('Error: $err'),
        data: (tasks) => tasks.isEmpty
            ? const EmptyState()
            : TaskList(tasks: tasks),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteConstants.taskDetail),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## Test Override Pattern

In unit tests — no widget tree needed:

```dart
test('TaskListNotifier returns tasks from repository', () async {
  final container = ProviderContainer(
    overrides: [
      taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
    ],
  );
  addTearDown(container.dispose);

  final tasks = await container.read(taskListProvider.future);
  expect(tasks, isEmpty);
});
```

In widget tests — wrap in `ProviderScope`:

```dart
testWidgets('HomeScreen shows tasks', (tester) async {
  final fakeRepo = FakeTaskRepository()
    ..seedWith([Task(id: '1', title: 'Buy milk', /* ... */)]);

  await tester.pumpWidget(ProviderScope(
    overrides: [taskRepositoryProvider.overrideWithValue(fakeRepo)],
    child: const MaterialApp(home: HomeScreen()),
  ));

  expect(find.text('Buy milk'), findsOneWidget);
});
```

---

## Mutability Rules

- **Never mutate state outside of a Notifier method**
- **Notifiers call use cases** — they do not contain business logic themselves
- **After any mutation, call `ref.invalidateSelf()`** — this triggers a fresh `build()` which re-fetches from the repository
- **Do not cache stale data** — let the use case + repository be the single source of truth
