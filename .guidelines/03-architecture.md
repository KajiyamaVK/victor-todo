# Architecture

## Clean Architecture Overview

taskem follows Clean Architecture with strict unidirectional dependencies across three layers.

```
┌──────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                       │
│  lib/presentation/                                        │
│  Flutter screens, widgets, Riverpod providers             │
│                                                           │
│  Depends on: domain (entities + use case interfaces)      │
│  Does NOT import from: data/                              │
└─────────────────────────┬────────────────────────────────┘
                          │ depends on
┌─────────────────────────▼────────────────────────────────┐
│  DOMAIN LAYER                                             │
│  lib/domain/                                              │
│  Entities, repository interfaces, use case classes        │
│                                                           │
│  Depends on: nothing (pure Dart)                          │
│  No Flutter imports. No drift imports.                    │
└─────────────────────────▲────────────────────────────────┘
                          │ implements / depends on
┌─────────────────────────┴────────────────────────────────┐
│  DATA LAYER                                               │
│  lib/data/                                                │
│  drift AppDatabase, DAOs, mappers, repository impls       │
│                                                           │
│  Depends on: domain (to implement interfaces)             │
│  Does NOT import from: presentation/                      │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  SERVICES (standalone)                                    │
│  lib/services/                                            │
│  FLOW LiteLLM stub (FlowService)                          │
│  No domain or presentation dependencies                   │
└──────────────────────────────────────────────────────────┘
```

---

## Layer Descriptions

### Domain Layer (Pure Dart)

The heart of the application. Contains all business rules.

**Entities** — Plain Dart classes (immutable, value-equality). No ORM annotations.

```dart
class Task {
  final String id;
  final String title;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final String? categoryId;
  final List<String> tagIds;
  final String? taskListId;
  // ...constructor, copyWith, ==, hashCode
}
```

**Repository Interfaces** — Abstract classes defining what persistence operations exist. The domain declares the contract; the data layer fulfills it.

```dart
abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<List<Task>> getTasksByList(String listId);
  Future<Task?> getTaskById(String id);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}
```

**Use Cases** — One class per operation. Thin orchestration — calls repository, enforces business rules.

```dart
class AddTaskUseCase {
  final TaskRepository _repository;
  AddTaskUseCase(this._repository);

  Future<void> execute(Task task) async {
    // Business rule: due date cannot be in the past
    if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
      throw ArgumentError('Due date cannot be in the past');
    }
    await _repository.addTask(task);
  }
}
```

---

### Data Layer (drift)

Implements domain repository interfaces using drift DAOs.

**AppDatabase** — Single drift `Database` subclass. Contains all table definitions.

**DAOs** — drift `DatabaseAccessor` subclasses. One DAO per entity. All queries live here.

**Mappers** — Pure functions converting between drift data classes and domain entities.

```dart
// drift data class → domain entity
Task toDomain(TaskData data) => Task(
  id: data.id,
  title: data.title,
  dueDate: data.dueDate,
  priority: Priority.values.byName(data.priority),
  isCompleted: data.isCompleted,
  // ...
);
```

**Repository Implementations** — Call DAO methods and use mappers.

---

### Presentation Layer (Flutter + Riverpod)

All UI code. Depends only on domain entities and use cases via Riverpod providers.

**Providers** bridge the domain use cases to the widget tree. They manage loading, error, and data states using `AsyncValue<T>`.

**Screens** consume providers via `ConsumerWidget` or `ConsumerStatefulWidget`.

**Widgets** are small, reusable UI components. They receive data as constructor parameters — no business logic inside widgets.

---

### Services Layer (FlowService)

Standalone HTTP client for the FLOW LiteLLM Proxy. No domain or presentation dependencies.

In this phase: returns a stub/mock response. The wiring, env var reading, and error handling are real — only the HTTP call is stubbed.

---

## Dependency Injection

Riverpod handles all dependency injection:

1. `AppDatabase` is provided via `databaseProvider` (a `Provider<AppDatabase>`)
2. DAOs are accessed through the database instance
3. Repository implementations are provided as `Provider<TaskRepository>`
4. Use cases are provided as `Provider<AddTaskUseCase>` etc., taking the repository as a constructor argument
5. UI state is managed by `NotifierProvider` or `AsyncNotifierProvider`

**Test override pattern:**

```dart
// In a test — override the repository with a fake:
final container = ProviderContainer(
  overrides: [
    taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
  ],
);
```

---

## Data Flow (Add Task Example)

```
User taps "Save" in TaskDetailScreen
  → calls ref.read(addTaskUseCaseProvider).execute(task)
  → AddTaskUseCase validates and calls TaskRepository.addTask()
  → TaskRepositoryImpl calls TaskDao.insertTask()
  → TaskDao inserts row into SQLite via drift
  → Provider notifies listeners
  → HomeScreen rebuilds with new task in list
```

---

## Notification Architecture

`flutter_local_notifications` is initialized in `main.dart`. When a task is saved with a due date and reminders enabled:

1. The use case calls a `NotificationService` (in `lib/services/`)
2. `NotificationService` schedules a local notification using the task's due date
3. On Linux, this uses libnotify via the flutter_local_notifications Linux plugin

The `NotificationService` receives the task ID and title as parameters. It does not import domain entities — it takes only primitive types to stay loosely coupled.
