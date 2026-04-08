# UI Design

## Theme

Dark UI using `ThemeData.dark()` with a custom colour palette defined in
`lib/presentation/theme/app_theme.dart`.

> **Rule:** Never use raw hex values in widgets. Always reference `AppTheme`
> constants so colour changes can be made in one place.

---

## Colour Palette

| Constant | Hex | Usage |
|---|---|---|
| `AppTheme.backgroundDark` | `#121212` | Scaffold background |
| `AppTheme.surfaceDark` | `#1E1E1E` | Cards, AppBar, input fill |
| `AppTheme.primaryAccent` | `#7C4DFF` | Deep purple — FAB, buttons, focused borders, highlights |
| `AppTheme.onPrimary` | `#FFFFFF` | Text / icons on primary-coloured surfaces |
| `AppTheme.textPrimary` | `#E0E0E0` | Titles and body text |
| `AppTheme.textSecondary` | `#9E9E9E` | Subtitles, hints, secondary labels |
| `AppTheme.priorityUrgent` | `#E53935` | Urgent priority badge |
| `AppTheme.priorityHigh` | `#FF7043` | High priority badge |
| `AppTheme.priorityMedium` | `#FFB300` | Medium priority badge |
| `AppTheme.priorityLow` | `#43A047` | Low priority badge |
| *(divider)* | `#2C2C2C` | Divider lines |
| *(input border resting)* | `#3C3C3C` | Input field border when not focused |

---

## Component Styles

### AppBar
- Background: `surfaceDark`
- Foreground (text / icons): `textPrimary`
- Elevation: `0` (flat, no shadow)

### Cards
- Background: `surfaceDark`
- Elevation: `2`
- Margin: `12px` horizontal, `4px` vertical

### FloatingActionButton
- Background: `primaryAccent`
- Foreground: `onPrimary`

### Input Fields
- Filled with `surfaceDark`
- Border radius: `8px` on all corners
- Resting border colour: `#3C3C3C`
- Focused border colour: `primaryAccent`
- Label colour: `textSecondary`
- Hint colour: `textSecondary`

### Checkboxes
- Unchecked: default (transparent fill)
- Checked: `primaryAccent` fill

---

## Priority Badges

Priority is displayed as a coloured text label using the `PriorityBadge`
widget. Always use the `AppTheme.priority*` constants — never hardcode colours.

| Priority | Constant | Hex |
|---|---|---|
| Urgent | `AppTheme.priorityUrgent` | `#E53935` |
| High | `AppTheme.priorityHigh` | `#FF7043` |
| Medium | `AppTheme.priorityMedium` | `#FFB300` |
| Low | `AppTheme.priorityLow` | `#43A047` |

---

## Screens

| Screen | File | Purpose |
|---|---|---|
| `HomeScreen` | `screens/home/home_screen.dart` | All-tasks unified view |
| `TaskListScreen` | `screens/task_list/task_list_screen.dart` | Tasks filtered by a named list |
| `TaskDetailScreen` | `screens/task_detail/task_detail_screen.dart` | Create / edit task form |
| `CategoriesScreen` | `screens/categories/categories_screen.dart` | List and add categories |
| `SettingsScreen` | `screens/settings/settings_screen.dart` | Placeholder (no settings in v1) |

All screen files live under `lib/presentation/screens/`.

---

## Reusable Widgets

| Widget | File | Purpose |
|---|---|---|
| `TaskTile` | `widgets/task_tile.dart` | Single task row: title, priority badge, due date chip, completion toggle, tag chips |
| `EmptyState` | `widgets/empty_state.dart` | Placeholder shown when a list has no tasks |
| `PriorityBadge` | `widgets/priority_badge.dart` | Coloured label for a priority level |
| `TagChip` | `widgets/tag_chip.dart` | Tag label displayed on a task tile |
| `DueDatePicker` | `widgets/due_date_picker.dart` | Date picker for setting a task's due date |

All widget files live under `lib/presentation/widgets/`.

---

## Layout Rules

### Max content width

On wide screens (desktop / web) list views and form bodies are capped at
**800 logical pixels** (`AppConstants.kContentMaxWidth`).

| Screen type | Widget wrapping | Alignment |
|---|---|---|
| List screens (`HomeScreen`, `TaskListScreen`) | `Align(topCenter)` → `ConstrainedBox(maxWidth: 800)` → `ListView` | Top-centred — content anchors to the top, not the vertical midpoint |
| Form screens (`TaskDetailScreen`) | `Center` → `ConstrainedBox(maxWidth: 800)` → `Form` | Horizontally centred |

`ConstrainedBox` is naturally a no-op when the available width is already
below the maximum, so no platform conditional is needed.

### Widget composition rules

- Screens consume Riverpod providers; widgets receive data via constructor
  parameters — no business logic inside widgets.
- Always use `const` constructors on widgets where possible to avoid
  unnecessary rebuilds.
- Widget state (`ConsumerStatefulWidget`) is used only when local ephemeral
  state is needed alongside provider data. Pure display widgets are always
  `ConsumerWidget` or plain `StatelessWidget`.
