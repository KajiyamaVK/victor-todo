# Technology Stack

## Stack Summary

| Technology | Version | Purpose | Why |
|---|---|---|---|
| **Flutter** | >=3.19 | UI framework, Linux desktop | Cross-platform; Linux desktop is first-class since Flutter 3 |
| **Dart** | >=3.3 | Language | Null-safe, excellent for Clean Architecture patterns |
| **drift** | ^2.18 | SQLite ORM | Type-safe queries, in-memory test mode, code generation |
| **drift_dev** | ^2.18 | drift code generator | Generates DAOs, table classes, query methods |
| **build_runner** | ^2.4 | Code generation runner | Required for drift and Riverpod code gen |
| **flutter_riverpod** | ^2.5 | State management | Testable without BuildContext, clean DI, code gen support |
| **riverpod_annotation** | ^2.3 | Riverpod annotations | `@riverpod` annotation for provider code gen |
| **riverpod_generator** | ^2.4 | Riverpod code generator | Generates providers from annotations |
| **flutter_local_notifications** | ^17 | Local notifications | Linux libnotify support, unified cross-platform API |
| **http** | ^1.2 | HTTP client | FlowService stub, lightweight |
| **flutter_dotenv** | ^5.1 | .env file loading | Load FLOW_API_KEY and FLOW_BASE_URL at runtime |
| **intl** | ^0.19 | Date/time formatting | Display-ready date strings |
| **uuid** | ^4.4 | UUID generation | Domain entity IDs |
| **mocktail** | ^1.0 | Mocking (test only) | No code gen required, clean null-safe API |

---

## ADR-001: Flutter for Linux Desktop

**Status:** Accepted

Flutter 3 ships first-class Linux desktop support. The app is built for Linux first. The same codebase can target web and mobile later by replacing platform-specific plugin implementations — no architectural changes needed.

---

## ADR-002: drift over sqflite

**Status:** Accepted

`NativeDatabase.memory()` is the decisive factor. It enables fully in-memory unit tests for all data layer code on Linux and CI — no device, no emulator, no `sqflite_ffi` initialization ceremony.

drift's generated DAOs also enforce type safety that raw SQL strings in sqflite cannot provide. Compile-time query checking prevents an entire class of runtime bugs.

**Linux desktop note:** drift uses `sqlite3` FFI directly (`drift/native.dart` + `sqlite3_flutter_libs`), which works on Linux without additional setup.

---

## ADR-003: Riverpod over BLoC

**Status:** Accepted

`ProviderContainer` allows any provider to be overridden in a test scope without mounting a widget tree. This means use case and repository tests are pure Dart unit tests — fast, no Flutter test runner overhead.

BLoC requires `bloc_test` for stream-based assertions and significantly more boilerplate (Event classes, State classes, Bloc class) per feature. Since TDD is mandatory, Riverpod's lighter test setup is a meaningful productivity advantage.

---

## ADR-004: mocktail over mockito

**Status:** Accepted

mockito requires `build_runner` to generate mock classes — meaning every interface refactor triggers a regeneration step. mocktail creates mocks at runtime with no codegen. Since drift already uses `build_runner`, keeping mock generation out of the mix keeps the build pipeline simpler.

---

## ADR-005: FLOW LiteLLM Stub (plumbing only)

**Status:** Accepted (stub phase)

`FlowService` mirrors `agents/shared/src/flow-provider.ts` from openauto-demos:
- Reads `FLOW_BASE_URL` (defaults to `https://flow.ciandt.com/flow-llm-proxy/v1`)
- Reads `FLOW_API_KEY` for Bearer authentication
- Returns a stub response in this phase

When AI features are activated, only `flow_service.dart` changes — the interface, env var names, and injection points remain stable.

---

## Environment Variables

| Variable | Purpose | Required |
|---|---|---|
| `FLOW_API_KEY` | Bearer token for FLOW LiteLLM Proxy | No (stub works without it) |
| `FLOW_BASE_URL` | LiteLLM Proxy base URL | No (defaults to production URL) |

Store in `.env` (gitignored). Document in `.env.example`.

```bash
# .env.example
FLOW_API_KEY=your_jwt_token_here
FLOW_BASE_URL=https://flow.ciandt.com/flow-llm-proxy/v1
```

---

## Code Generation

Two packages use `build_runner`:

| Package | What it generates |
|---|---|
| drift_dev | `app_database.g.dart` — table data classes, query implementations |
| riverpod_generator | `*.g.dart` files for `@riverpod`-annotated providers |

**Regenerate when:**
- A drift table definition changes
- A `@riverpod` provider signature changes

**Command:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files are committed to the repository. Do not add `*.g.dart` to `.gitignore`.
