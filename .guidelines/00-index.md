# taskem — Guidelines Index

This folder contains reference guidelines for AI agents and developers working on taskem. Read these files **before writing any code** to understand the project's goals, architecture, conventions, and constraints.

## Files

| File | Contents |
|---|---|
| [01-project-overview.md](./01-project-overview.md) | What taskem is, goals, features in scope, features out of scope |
| [02-folder-structure.md](./02-folder-structure.md) | Exact directory layout, what lives where — do not restructure without reading this |
| [03-architecture.md](./03-architecture.md) | Clean Architecture layers, dependency rules, layer descriptions |
| [04-technology-stack.md](./04-technology-stack.md) | Flutter, Dart, drift, Riverpod, flutter_local_notifications — why each was chosen |
| [05-coding-guidelines.md](./05-coding-guidelines.md) | Dart conventions, naming, imports, formatting, error handling, comments |
| [06-testing-strategy.md](./06-testing-strategy.md) | TDD enforcement, test structure, drift in-memory DB, mocktail patterns |
| [07-state-management.md](./07-state-management.md) | Riverpod patterns, provider definitions, how providers connect to use cases |
| [08-what-to-build.md](./08-what-to-build.md) | Feature backlog and build order — what is in scope and what is not |

## Quick Orientation

**What are we building?**
A personal Flutter Todo app for Linux desktop with dark UI, SQLite persistence, and local notification reminders. Designed for future portability to web and mobile.

**What is the architecture?**
Clean Architecture with three strict layers: domain (pure Dart), data (drift + DAOs), and presentation (Flutter + Riverpod). Layers have a one-way dependency rule — see [03-architecture.md](./03-architecture.md).

**How is state managed?**
Riverpod. Providers connect use cases to the UI. `ProviderContainer` allows test-only overrides without a widget tree.

**How is data persisted?**
drift ORM on top of SQLite via `sqlite3` FFI for Linux desktop. `NativeDatabase.memory()` powers in-memory tests.

**What is the LiteLLM stub?**
`FlowService` in `lib/services/flow/` — reads `FLOW_API_KEY` and `FLOW_BASE_URL`, returns stub data. No AI features are active yet.

**What is the test approach?**
TDD is mandatory. Every feature starts with a failing test. See [06-testing-strategy.md](./06-testing-strategy.md).
