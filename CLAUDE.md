# CLAUDE.md — taskem

## MANDATORY: Read Guidelines Before Doing Anything

This project has mandatory reference documents that must be read before writing any code, making architectural decisions, or adding features.

```
.guidelines/00-index.md          ← Start here — quick orientation
.guidelines/01-project-overview.md
.guidelines/02-folder-structure.md
.guidelines/03-architecture.md
.guidelines/04-technology-stack.md
.guidelines/05-coding-guidelines.md
.guidelines/06-testing-strategy.md
.guidelines/07-state-management.md
.guidelines/08-what-to-build.md
```

### Why the Guidelines Exist

This is a personal Flutter Todo app with a strict Clean Architecture structure and mandatory TDD. Without reading the guidelines, it is easy to:

- Add features not in scope
- Couple layers that must stay separate (domain must have zero Flutter dependencies)
- Write implementation code before writing a failing test
- Violate naming conventions that must remain consistent across domain, data, and presentation layers

If you have not read the guidelines, stop and read them now.

---

## Project at a Glance

| What | Value |
|---|---|
| **What we're building** | Personal Flutter Todo app for Linux desktop (future web/mobile portability) |
| **Platform target** | Linux desktop (primary), future: web + mobile |
| **Language** | Dart 3 / Flutter 3.19+ |
| **Architecture** | Clean Architecture: domain / data / presentation layers |
| **State management** | Riverpod (`flutter_riverpod` + `riverpod_generator`) |
| **Database** | SQLite via drift (type-safe ORM with in-memory test mode) |
| **Theme** | Dark UI (`ThemeData.dark()` with custom colour palette) |
| **LLM stub** | FLOW LiteLLM Proxy (plumbing only — no AI features yet) |
| **Testing** | TDD mandatory (Red-Green-Refactor) |
| **GitHub** | `KajiyamaVK/taskem` (personal account) |

---

## TDD Enforcement (Strict)

For **every new feature**, the Red-Green-Refactor cycle is mandatory and non-negotiable:

1. **Write the failing test first** — no implementation code until there is at least one failing test that describes the expected behavior
2. **Confirm red** — run the test suite and verify the new test fails (red) before writing any implementation
3. **Only then implement** — write the minimum code to make the test pass (green)
4. **Refactor** — clean up while keeping tests green

> **Existing code is exempt.** Do not retrofit tests onto already-shipped functionality. This rule applies only to new development starting from this point forward.

If you are about to write implementation code for a new feature and there are no failing tests yet — **stop**. Write the test first.

### Commands

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/unit/domain/entities/task_test.dart

# Run with coverage
flutter test --coverage

# Format all Dart files
dart format .

# Lint + type check
dart analyze

# Regenerate drift code after schema changes
dart run build_runner build --delete-conflicting-outputs

# Run on Linux desktop (debug)
flutter run -d linux

# Build Linux desktop release
flutter build linux
```

**Pre-commit sequence (always run in this order):**

```bash
dart format . && dart analyze && flutter test
```

---

## Hard Rules (No Exceptions)

| # | Rule |
|---|---|
| 1 | **Read `.guidelines/` first** — always, every session, before touching code |
| 2 | **TDD** — write failing test before implementation (see TDD Enforcement above) |
| 3 | **Domain layer is pure Dart** — no Flutter imports in `lib/domain/` |
| 4 | **No direct layer skipping** — presentation never imports from `data/`; go through `domain/` repositories |
| 5 | **No hardcoded strings** — use constants in `lib/core/constants/` |
| 6 | **Run `dart analyze && flutter test` before every commit** |
| 7 | **Run `dart format .` before every commit** |
| 8 | **Never commit `.env`** — use `.env.example` to document required variables |
| 9 | **One use case per class** — no god-object use case classes |
| 10 | **Comments are required** — explain non-obvious logic so the codebase is understandable in future sessions |

---

## Related Documents

- `.guidelines/` — Development guidelines: architecture, conventions, what to build
- `.env.example` — Required environment variable documentation
