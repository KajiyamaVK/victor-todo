# Project Overview

## What This Project Is

**taskem** is Victor's personal Flutter Todo app targeting Linux desktop, designed with future portability to web and mobile in mind.

The app is a productivity tool — no AI features in this phase. The LiteLLM integration is wired as plumbing only, ready for future AI enhancements.

## Project Goals

1. **Personal daily task management** — Add, complete, and organize tasks with due dates, priorities, and reminders.
2. **Clean Architecture baseline** — A well-structured Flutter project that can be extended without coupling issues.
3. **TDD discipline** — Every feature is test-driven from the start, preventing regressions as the app grows.
4. **Future portability** — Linux desktop first; no platform-specific code that would block web or mobile later.
5. **LiteLLM integration plumbing** — `FlowService` stub is in place so AI features can be activated without restructuring.

## Features In Scope

| Feature | Notes |
|---|---|
| Add / edit / delete tasks | Core CRUD |
| Complete tasks | Toggle completion, mark done |
| Due dates | Date picker, stored as ISO date |
| Reminders | Local notifications via `flutter_local_notifications` |
| Categories | One category per task |
| Tags | Multi-select tags per task |
| Priorities | Enum: low / medium / high / urgent |
| Lists | Named lists to group tasks; "All Tasks" view is the default |
| Sort by date | Default sort order: due date ascending |
| Dark theme | Custom dark colour palette via `ThemeData.dark()` |

## Features Out of Scope

> Do not build these. They are not planned for this phase.

- Cloud sync or multi-device sync
- User accounts or authentication
- Collaboration / sharing
- AI-powered suggestions (LiteLLM stub is wired, not active)
- Web or mobile builds (architecture supports it, but not the current target)
- Export / import
- Recurring tasks

## Technical Context

| Field | Value |
|---|---|
| **Repo** | `KajiyamaVK/taskem` (personal GitHub) |
| **Language** | Dart 3 / Flutter 3.19+ |
| **Platform** | Linux desktop (flutter run -d linux) |
| **Database** | SQLite via drift |
| **State management** | Riverpod |
| **Testing** | TDD mandatory — flutter_test + mocktail |
