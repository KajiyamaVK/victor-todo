# Testing Strategy

## TDD is Mandatory

Every feature follows the **Red → Green → Refactor** cycle, non-negotiable:

1. **Red** — Write a failing test that describes the expected behavior. Run it. Confirm it fails.
2. **Green** — Write the minimum implementation to make the test pass. Run it. Confirm it passes.
3. **Refactor** — Clean up implementation and tests while keeping everything green.

> If you are about to write implementation code and there is no failing test yet — stop. Write the test first.

---

## Test Layers

### Unit Tests (`test/unit/`)

Fast, isolated, no Flutter framework. Run with `dart test` or `flutter test`.

**Domain tests** (`test/unit/domain/`):
- Entity equality, `copyWith`, field validation
- Use case business rule enforcement (invalid input, edge cases)
- Use cases tested with fake repository implementations (not mocks — see below)

**Data tests** (`test/unit/data/`):
- DAO tests use `NativeDatabase.memory()` — spin up an in-memory SQLite database in test setup
- Mapper tests verify bidirectional conversion: drift data class → domain entity and back

**Service tests** (`test/unit/services/`):
- `FlowService` stub: verify env var reading, correct header construction, correct URL building, stubbed response parsing

### Widget Tests (`test/widget/`)

Flutter widget tests using `flutter_test`. Mount individual screens or widgets in a `ProviderScope` with overridden providers.

- Screen tests: verify correct content renders given different provider states (loading, data, empty, error)
- Widget tests: verify `TaskTile` renders title, priority badge, completion toggle

### Integration Tests (`test/integration/`)

Not required for the initial build. Placeholder for future end-to-end flows.

---

## drift In-Memory Database Pattern

All DAO tests use an in-memory database. This is drift's official test pattern:

```dart
// test/unit/data/daos/task_dao_test.dart

late AppDatabase db;
late TaskDao taskDao;

setUp(() {
  // NativeDatabase.memory() creates a fresh in-memory SQLite db
  db = AppDatabase(NativeDatabase.memory());
  taskDao = db.taskDao;
});

tearDown(() async {
  await db.close();
});

test('insertTask stores a task and getTaskById returns it', () async {
  // Red: write this test before implementing insertTask
  await taskDao.insertTask(/* TasksCompanion */);
  final result = await taskDao.getTaskById('task-id-1');
  expect(result?.title, equals('Buy milk'));
});
```

**Key point:** Tests run in milliseconds — no device, no emulator, no async delays.

---

## Fake Repositories vs. Mocks

**Prefer fake repositories over mocks for use case tests.**

A fake repository is a simple in-memory implementation of the repository interface:

```dart
// test/helpers/fake_task_repository.dart
class FakeTaskRepository implements TaskRepository {
  final _tasks = <String, Task>{};

  @override
  Future<void> addTask(Task task) async => _tasks[task.id] = task;

  @override
  Future<List<Task>> getAllTasks() async => _tasks.values.toList();

  @override
  Future<Task?> getTaskById(String id) async => _tasks[id];

  // ...other methods
}
```

Use **mocktail** when you need to verify that a method was called with specific arguments (interaction testing), or when you do not want to implement all interface methods:

```dart
class MockTaskRepository extends Mock implements TaskRepository {}

test('AddTaskUseCase calls repository.addTask once', () async {
  final repo = MockTaskRepository();
  when(() => repo.addTask(any())).thenAnswer((_) async {});

  await AddTaskUseCase(repo).execute(task);

  verify(() => repo.addTask(task)).called(1);
});
```

---

## Riverpod Provider Testing

Override providers with `ProviderContainer` — no widget tree needed:

```dart
test('taskListProvider returns tasks from repository', () async {
  final container = ProviderContainer(
    overrides: [
      taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
    ],
  );
  addTearDown(container.dispose);

  // Trigger the provider
  final tasks = await container.read(taskListProvider.future);
  expect(tasks, isEmpty);
});
```

---

## Widget Test Pattern

Use `ProviderScope` with overrides in widget tests:

```dart
testWidgets('HomeScreen shows empty state when no tasks', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        taskListProvider.overrideWith((_) => AsyncValue.data([])),
      ],
      child: const MaterialApp(home: HomeScreen()),
    ),
  );

  expect(find.byType(EmptyState), findsOneWidget);
});
```

---

## Coverage Expectations

| Layer | Minimum coverage goal |
|---|---|
| Domain entities | 100% — pure Dart, trivial to test |
| Domain use cases | 100% — business rules must be verified |
| Data mappers | 100% — bidirectional conversion |
| Data DAOs | 80%+ — all main query paths |
| Presentation providers | 70%+ — loading, data, error states |
| FlowService | 80%+ — stub response, header construction |

Run `flutter test --coverage` to generate `coverage/lcov.info`.

---

## Test File Naming

Every production file has a corresponding test file:

| Production | Test |
|---|---|
| `lib/domain/entities/task.dart` | `test/unit/domain/entities/task_test.dart` |
| `lib/domain/usecases/task/add_task_use_case.dart` | `test/unit/domain/usecases/task/add_task_use_case_test.dart` |
| `lib/data/daos/task_dao.dart` | `test/unit/data/daos/task_dao_test.dart` |
| `lib/data/mappers/task_mapper.dart` | `test/unit/data/mappers/task_mapper_test.dart` |
| `lib/services/flow/flow_service.dart` | `test/unit/services/flow_service_test.dart` |
