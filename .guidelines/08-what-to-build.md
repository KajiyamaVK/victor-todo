# What to Build

This file defines the canonical scope and build order for taskem. Do not build features not on this list without explicit approval.

---

## Feature Backlog

### Core Task Management

- [ ] Task entity with: id, title, due date, priority, completion status, category, tags, list
- [ ] Add task (with TDD)
- [ ] Edit task (with TDD)
- [ ] Delete task (with TDD)
- [ ] Complete / uncomplete task (with TDD)
- [ ] List all tasks (sorted by due date ascending, nulls last)

### Categories

- [ ] Category entity with: id, name, colour
- [ ] Add category
- [ ] List categories
- [ ] Assign category to task

### Tags

- [ ] Tag entity with: id, name
- [ ] Add tag
- [ ] List tags
- [ ] Assign multiple tags to a task (many-to-many)

### Lists

- [ ] TaskList entity with: id, name
- [ ] Add list
- [ ] List all lists
- [ ] Filter tasks by list
- [ ] "All Tasks" view (default, no filter)

### Priorities

- [ ] Priority enum: low, medium, high, urgent
- [ ] Display priority badge in task tile
- [ ] Filter/sort by priority (bonus, not blocking)

### Reminders

- [ ] Schedule local notification for a task's due date
- [ ] Cancel notification when task is completed or deleted
- [ ] Cancel notification when due date is changed

### UI / Theme

- [ ] Dark theme (`AppTheme` class with `ThemeData.dark()` and custom palette)
- [ ] HomeScreen: all tasks view
- [ ] TaskListScreen: tasks filtered by named list
- [ ] TaskDetailScreen: create and edit task form
- [ ] CategoriesScreen: list and add categories
- [ ] SettingsScreen: placeholder (no settings in v1)
- [ ] EmptyState widget: shown when a list has no tasks
- [ ] TaskTile widget: title, priority badge, due date chip, completion toggle
- [ ] Tag chips on task tile

### Infrastructure

- [ ] drift schema: tasks, categories, tags, task_lists, task_tags join table
- [ ] Migrations: v1 initial schema
- [ ] FlowService stub: reads env vars, returns mock response
- [ ] `analysis_options.yaml` with recommended lints
- [ ] `.env.example` documenting FLOW_API_KEY and FLOW_BASE_URL
- [ ] GitHub repo created at `KajiyamaVK/taskem` (private)

---

## Build Order (Recommended)

1. **Domain layer** — entities + repository interfaces + use cases (TDD first)
2. **Data layer** — drift schema (designed by DBA), DAOs, mappers, repository implementations (TDD with in-memory DB)
3. **Services** — FlowService stub
4. **Presentation — providers** — Riverpod wiring (TDD with ProviderContainer)
5. **Presentation — theme** — AppTheme dark palette
6. **Presentation — screens and widgets** — HomeScreen, TaskDetailScreen, etc. (widget tests)
7. **Notifications** — wire flutter_local_notifications after core UI is stable
8. **GitHub push** — init git, create repo, push

---

## What Is Explicitly NOT In Scope

Do not build these without explicit scope change from Victor:

- Cloud sync, backup, or multi-device
- Authentication or user accounts
- AI / LLM features (FlowService stub is wired — do not activate)
- Recurring tasks
- Task dependencies
- Sub-tasks / checklists
- Time tracking
- Web or mobile builds (architecture supports it; don't configure it now)
- Export / import (CSV, JSON, etc.)
- Collaboration or sharing

---

## Bonus Goals (Not Blocking)

- Filter tasks by priority
- Filter tasks by tag
- Search tasks by title
- Sort tasks by priority (in addition to date)
- Drag-and-drop task reordering
