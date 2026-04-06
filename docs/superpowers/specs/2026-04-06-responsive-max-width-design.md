# Design: Responsive Max-Width Constraint for List and Form Screens

**Date:** 2026-04-06
**Status:** Approved

## Problem

On web and desktop, three screens stretch their content to the full viewport width, which is visually uncomfortable on wide displays:

- `HomeScreen` — all-tasks `ListView`
- `TaskListScreen` — filtered-list `ListView`
- `TaskDetailScreen` — new/edit task form `ListView`

## Solution

Wrap the `body` content of each screen in a `Center` + `ConstrainedBox` with `maxWidth: 800`. On screens narrower than 800px (e.g. mobile), the constraint never activates and layout is unchanged.

No platform or breakpoint conditional is needed — `ConstrainedBox` is naturally a no-op when the available width is already below the maximum.

## Affected Files

| File | Change |
|---|---|
| `lib/presentation/screens/home/home_screen.dart` | Wrap `body` content in `Center` + `ConstrainedBox(maxWidth: 800)` |
| `lib/presentation/screens/task_list/task_list_screen.dart` | Same |
| `lib/presentation/screens/task_detail/task_detail_screen.dart` | Same — wraps the `Form(child: ListView(...))` |

## Constants

The `800` value is extracted to `AppConstants` as `kContentMaxWidth = 800.0` to avoid magic numbers and allow future global adjustment.

## Testing

Widget tests verify that each screen's `body` contains a `ConstrainedBox` with `maxWidth == 800` at the top of the widget tree. No new platform-specific test infrastructure is required.

## Out of Scope

- Other screens (Settings, Categories) — not requested
- Responsive sidebar or navigation layout changes
- Per-platform breakpoint logic
