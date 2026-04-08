# Coding Guidelines

## Language and Runtime

- **Dart 3** — all implementation code; use null safety everywhere
- **Flutter 3.19+** — in `lib/presentation/` only
- **Pure Dart** — `lib/domain/` has zero Flutter or drift imports
- **Always use `const` constructors** where possible in widgets
- **Prefer `final`** over `var` for local variables

---

## Formatting

Run `dart format .` before every commit. No manual formatting.

| Setting | Value |
|---|---|
| Indentation | 2 spaces (Dart default) |
| Line length | 80 characters |
| Line endings | LF (Unix) |
| Final newline | Required |

---

## Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Files | snake_case | `task_repository.dart`, `add_task_use_case.dart` |
| Variables / functions | lowerCamelCase | `addTask`, `dueDate`, `taskRepository` |
| Classes | UpperCamelCase | `Task`, `TaskRepository`, `AddTaskUseCase` |
| Enums | UpperCamelCase values | `Priority.high`, `Priority.urgent` |
| Global constants | UPPER_SNAKE_CASE | `MAX_TAGS_PER_TASK` |
| Local constants | lowerCamelCase | `defaultPriority` |
| Riverpod providers | lowerCamelCase + `Provider` suffix | `taskListProvider` |
| drift Tables | UpperCamelCase | `Tasks`, `Tags`, `Categories` |
| Test files | snake_case + `_test.dart` | `add_task_use_case_test.dart` |

---

## Import Order

Dart's `linter` enforces `directives_ordering`. Follow this order:

```dart
// 1. dart: core
import 'dart:async';

// 2. package: flutter
import 'package:flutter/material.dart';

// 3. package: third-party
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 4. package: local (absolute)
import 'package:taskem/domain/entities/task.dart';

// 5. relative (only within same sub-folder)
import '../repositories/task_repository.dart';
```

---

## Entities (Domain Layer)

- **Immutable** — all fields are `final`
- **Value equality** — override `==` and `hashCode` (or use `Equatable`)
- **`copyWith`** — always provide a `copyWith` method for updates
- **No ORM annotations** — drift annotations live only in `lib/data/`

```dart
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.isCompleted,
    this.dueDate,
    this.categoryId,
    this.taskListId,
    this.tagIds = const [],
  });

  final String id;
  final String title;
  final Priority priority;
  final bool isCompleted;
  final DateTime? dueDate;
  final String? categoryId;
  final String? taskListId;
  final List<String> tagIds;

  Task copyWith({/* all fields optional */}) => Task(/* ... */);

  @override
  bool operator ==(Object other) => /* compare all fields */;

  @override
  int get hashCode => /* hash all fields */;
}
```

---

## Use Cases

- One public method per class: `execute()` or a named verb
- Constructor takes repository as a parameter (injected by Riverpod)
- Validate business rules before delegating to the repository
- Return domain entities, never drift data classes

```dart
class AddTaskUseCase {
  const AddTaskUseCase(this._repository);
  final TaskRepository _repository;

  /// Adds a new task. Throws [ArgumentError] if due date is in the past.
  Future<void> execute(Task task) async {
    if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
      throw ArgumentError('Due date cannot be in the past');
    }
    await _repository.addTask(task);
  }
}
```

---

## Error Handling

- **Never swallow errors silently** — always rethrow or log
- **Repository implementations** — wrap drift exceptions in domain-level exceptions (e.g., `DatabaseException`)
- **Use cases** — throw `ArgumentError` for invalid input (business rule violations)
- **Providers** — `AsyncValue` handles errors for the UI; `AsyncValue.error` state is rendered as an error widget
- **FlowService** — throws `FlowException` subtypes; callers handle `FlowConnectionException` vs. `FlowAuthException`

---

## Comments

Comments are **required** on non-obvious logic. Since this is a vibe-coded personal project, every class and non-trivial method must have a doc comment explaining what it does and why.

```dart
/// Repository interface for task persistence.
///
/// Implementations must be provided via Riverpod. The domain layer declares
/// this interface; [TaskRepositoryImpl] in the data layer implements it.
abstract class TaskRepository {
  /// Returns all tasks sorted by [Task.dueDate] ascending (nulls last).
  Future<List<Task>> getAllTasks();
  // ...
}
```

Rules:
- Every abstract class: doc comment explaining purpose
- Every use case class: doc comment on `execute()` describing business rules enforced
- Non-obvious logic: inline comment explaining the why, not the what
- No TODO comments — create a tracked issue instead

---

## Code Style Rules

- **No `dynamic`** — use explicit types or `Object?` if truly unknown
- **No non-null assertion (`!`)** without a preceding null check or a clear code comment explaining why it cannot be null at that point
- **No commented-out code** — git remembers; delete it
- **`const` constructors** — always use them in widgets; prefer them in entities
- **Prefer expression bodies** for simple one-liner functions
- **Explicit return types** on all functions in `lib/domain/`

---

## Pre-Commit Checklist

Before every commit, run:

```bash
dart format .           # Auto-format
dart analyze            # Lint + type check (must pass with 0 issues)
flutter test            # All tests must pass
```

If `dart analyze` reports any issue, fix it before committing. The project uses a strict `analysis_options.yaml` with `pedantic` rules enabled.

Then self-review all changed files and verify:

- Dart conventions (naming, imports, formatting) are followed
- Layer isolation is not violated (presentation → domain only; domain has no Flutter/drift imports)
- New code has test coverage
- Non-obvious logic has comments explaining the why
- No hardcoded strings (use `lib/core/constants/`)
- No secrets or `.env` files staged

---

## Commit Message Format

```
<type>: <short description>

<optional longer body if needed>
```

**Types:**

| Type | When to use |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `test` | Adding or updating tests only |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `docs` | Documentation only |
| `chore` | Build, tooling, dependency updates |

**Examples:**

```
feat: add task creation use case with due date support
test: add unit tests for CategoryRepository
fix: correct drift migration from version 1 to 2
chore: run drift code generation after adding Tags table
```

---

## Architectural Changes

For commits that introduce any of the following, pause and re-read `.guidelines/03-architecture.md` before committing:

- New external dependencies (`pubspec.yaml` changes)
- drift schema changes (new tables, columns, or migrations)
- Changes to repository interfaces in `lib/domain/`
- New architectural patterns or cross-layer wiring

These changes have larger blast radius — verify layer isolation is preserved before proceeding.
