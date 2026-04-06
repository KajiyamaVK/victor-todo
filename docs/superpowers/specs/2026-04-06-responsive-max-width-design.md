# Design: Responsive Max-Width Constraint for List and Form Screens

**Date:** 2026-04-06
**Status:** Approved

## Problem

On web and desktop, three screens stretch their content to the full viewport width, which is visually uncomfortable on wide displays:

- `HomeScreen` — all-tasks `ListView`
- `TaskListScreen` — filtered-list `ListView`
- `TaskDetailScreen` — new/edit task form `ListView`

## Solution

Apply `ConstrainedBox(maxWidth: 800)` differently per screen type:

**List screens** (`HomeScreen`, `TaskListScreen`) — apply only inside the `data` branch of `tasksAsync.when(...)`, wrapping the `ListView.builder`. Loading and error branches are left untouched so their existing `Center` widgets continue to fill the screen properly. Use `Align(alignment: Alignment.topCenter)` rather than `Center` so the constrained list anchors to the top, not the vertical midpoint.

**Form screen** (`TaskDetailScreen`) — wrap the entire `Form` body. There is no `when()` branching here, so wrapping the whole body is correct. `Center` is appropriate since the form should sit horizontally centred.

No platform or breakpoint conditional is needed — `ConstrainedBox` is naturally a no-op when available width is already below the maximum.

## Affected Files

| File | Change |
|---|---|
| `lib/presentation/screens/home/home_screen.dart` | In `data` branch: wrap `ListView.builder` in `Align(topCenter)` + `ConstrainedBox(maxWidth: 800)` |
| `lib/presentation/screens/task_list/task_list_screen.dart` | Same |
| `lib/presentation/screens/task_detail/task_detail_screen.dart` | Wrap full `Form` body in `Center` + `ConstrainedBox(maxWidth: 800)` |

## Constants

The `800` value is extracted to `AppConstants` as `kContentMaxWidth = 800.0` to avoid magic numbers and allow future global adjustment.

## Testing

Widget tests verify:
- `HomeScreen` and `TaskListScreen`: the `data` branch renders a `ConstrainedBox(maxWidth: 800)` wrapping the list; loading/error branches do NOT contain a `ConstrainedBox`.
- `TaskDetailScreen`: the body contains a `ConstrainedBox(maxWidth: 800)` wrapping the form.

No platform-specific test infrastructure is required.

## Out of Scope

- Other screens (Settings, Categories) — not requested
- Responsive sidebar or navigation layout changes
- Per-platform breakpoint logic
