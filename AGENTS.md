# AGENTS.md — taskem

This document provides guidelines for AI agents working on the taskem Flutter project.

## Project Overview

**taskem** — Personal Flutter Todo app for Linux desktop with future portability to web and mobile. Built with Clean Architecture, SQLite persistence via drift, Riverpod state management, and a dark UI.

### Project Layers

| Layer | Path | Purpose |
|---|---|---|
| Domain | `lib/domain/` | Entities, repository interfaces, use cases. Pure Dart — zero Flutter dependencies. |
| Data | `lib/data/` | drift database, DAOs, mappers, concrete repository implementations |
| Presentation | `lib/presentation/` | Screens, widgets, Riverpod providers, dark theme |
| Services | `lib/services/` | FLOW LiteLLM stub and other external service clients |
| Core | `lib/core/` | Constants, utilities shared across layers |
| Tests | `test/` | Unit, widget, integration tests |

### Key Features (In Scope)

- Add / edit / complete tasks
- Due dates
- Reminders (local notifications via `flutter_local_notifications`)
- Categories
- Tags (multi-select per task)
- Priorities
- Lists (task grouping) + "All Tasks" unified view
- Sort by date (default)
- Dark theme

### What Is Out of Scope

- Any real AI / LLM features (FLOW stub is plumbing only)
- Multi-user or sync functionality
- Cloud persistence
- Authentication

---

## Build / Test / Format Commands

```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/unit/domain/use_cases/add_task_use_case_test.dart

# Run with coverage
flutter test --coverage

# Format all Dart files
dart format .

# Analyze code (lint + type check)
dart analyze

# Run drift code generation
dart run build_runner build --delete-conflicting-outputs

# Run in debug mode (Linux desktop)
flutter run -d linux

# Build release (Linux desktop)
flutter build linux
```

**Pre-commit sequence (always run in this order):**
```bash
dart format . && dart analyze && flutter test
```

---

## Code Style Guidelines

### Formatting (dart format)

- **Indentation:** 2 spaces (Dart standard)
- **Line length:** 80 characters (Dart default)
- **Line endings:** LF (Unix)
- **Final newline:** Required
- Run `dart format .` before every commit — no manual formatting

### Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Files | snake_case | `task_repository.dart`, `add_task_use_case.dart` |
| Variables / functions | lowerCamelCase | `addTask`, `dueDate`, `taskRepository` |
| Classes | UpperCamelCase | `Task`, `TaskRepository`, `AddTaskUseCase` |
| Constants | lowerCamelCase or UPPER_SNAKE_CASE for global | `defaultDueDate`, `MAX_TASKS_PER_LIST` |
| Riverpod providers | lowerCamelCase + `Provider` suffix | `taskListProvider`, `addTaskUseCaseProvider` |
| drift Tables | UpperCamelCase | `Tasks`, `Categories`, `Tags` |
| drift Companions | auto-generated (`TasksCompanion`) | (do not rename) |
| Test files | snake_case + `_test.dart` | `task_repository_test.dart` |

### Import Order (enforced by lint)

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Third-party packages
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 4. Local — absolute package imports
import 'package:taskem/domain/entities/task.dart';

// 5. Local — relative imports (only within the same layer)
import '../repositories/task_repository.dart';
```

### Layer Dependency Rules

```
presentation  →  domain  (via providers)
data          →  domain  (implements interfaces)
domain        →  (nothing — pure Dart only)
services      →  (nothing — standalone stubs)
```

**Violations:**
- Presentation must NOT import directly from `data/`
- Domain must NOT import `package:flutter/*` or `package:drift/*`
- Data must NOT import `package:flutter_riverpod/*`

---

## Commit Review Process

Every commit must go through review before being finalized.

### Workflow

1. **Implement** the changes following TDD (failing test → implementation → refactor).
2. **Run the pre-commit sequence:** `dart format . && dart analyze && flutter test`
3. **Self-review all changed files** checking:
   - Dart conventions (naming, imports, formatting)
   - Layer isolation not violated
   - New code has test coverage
   - Comments on non-obvious logic
   - No hardcoded strings or secrets
4. **Fix all findings** before committing.
5. **Commit** with a descriptive message referencing the feature or issue.

### Commit Message Format

```
<type>: <short description>

<optional longer body if needed>
```

Types: `feat`, `fix`, `test`, `refactor`, `docs`, `chore`

Examples:
```
feat: add task creation use case with due date support
test: add unit tests for CategoryRepository
fix: correct drift migration from version 1 to 2
chore: run drift code generation after adding Tags table
```

### Architectural Changes (Additional Step)

For commits that add new dependencies, change the drift schema, alter repository interfaces, or introduce new architectural patterns — pause and verify against `.guidelines/03-architecture.md` before committing.

---

## Related Documents

- `CLAUDE.md` — Mandatory reading, TDD enforcement, hard rules
- `.guidelines/` — Full guidelines: architecture, conventions, what to build
- `.env.example` — Required environment variable documentation
