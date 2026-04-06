// lib/data/datasources/database/app_database.dart
// Run: dart run build_runner build --delete-conflicting-outputs
// after modifying this file to regenerate app_database.g.dart

import 'package:drift/drift.dart';

// DAO imports — must come before the part directive.
import '../daos/category_dao.dart';
import '../daos/tag_dao.dart';
import '../daos/task_dao.dart';
import '../daos/task_list_dao.dart';

// Required part directive — drift generates _$AppDatabase into this file.
part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Table: Categories
// Groups tasks by topic (e.g., "Work", "Personal").
// Defined before Tasks so drift resolves the FK reference.
// ---------------------------------------------------------------------------
class Categories extends Table {
  /// UUID string — generated in Dart before insert.
  TextColumn get id => text()();

  /// Human-readable category name — must be unique.
  TextColumn get name => text().withLength(min: 1, max: 255).unique()();

  /// Colour expressed as a hex string, e.g. "#FF5722".
  TextColumn get colour => text().withLength(min: 4, max: 9)();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Table: TaskLists
// Named lists that group tasks (e.g., "Shopping", "Work Projects").
// "All Tasks" is a UI concept — it has no row here.
// ---------------------------------------------------------------------------
class TaskLists extends Table {
  /// UUID string — generated in Dart before insert.
  TextColumn get id => text()();

  /// Human-readable list name — must be unique.
  TextColumn get name => text().withLength(min: 1, max: 255).unique()();

  /// Optional free-form description for the list.
  TextColumn get description => text().nullable()();

  /// Unix timestamp (milliseconds since epoch) — set at creation time.
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Table: Tags
// Labels that can be applied to many tasks (many-to-many via TaskTags).
// ---------------------------------------------------------------------------
class Tags extends Table {
  /// UUID string — generated in Dart before insert.
  TextColumn get id => text()();

  /// Tag label — must be unique across all tags.
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Table: Tasks
// The core entity. Every other table relates to this one.
// ---------------------------------------------------------------------------
class Tasks extends Table {
  /// UUID string — generated in Dart before insert.
  TextColumn get id => text()();

  /// Short title of the task — required, max 500 chars.
  TextColumn get title => text().withLength(min: 1, max: 500)();

  /// Optional long-form description.
  TextColumn get description => text().nullable()();

  /// Optional due date stored as Unix ms timestamp.
  IntColumn get dueDate => integer().nullable()();

  /// Priority level: 'low' | 'medium' | 'high' | 'urgent'.
  /// Stored as text; Dart code enforces valid values at the app layer.
  TextColumn get priority => text().withDefault(const Constant('medium'))();

  /// Whether the task has been completed.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// Unix ms timestamp set when the task is marked complete; null if not done.
  IntColumn get completedAt => integer().nullable()();

  /// Optional FK to Categories. Nulled out (not cascaded) if the category
  /// is deleted — handled by the app layer.
  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Optional FK to TaskLists. Nulled out if the list is deleted.
  TextColumn get taskListId => text().nullable().references(TaskLists, #id)();

  /// Unix ms timestamp — set once at creation, never changed.
  IntColumn get createdAt => integer()();

  /// Unix ms timestamp — updated on every write; managed by the repository.
  IntColumn get updatedAt => integer()();

  /// Optional reminder time stored as Unix ms timestamp.
  IntColumn get reminderTime => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Table: TaskTags
// Join table for the many-to-many relationship between Tasks and Tags.
// Rows here are cascade-deleted when the parent Task is deleted.
// ---------------------------------------------------------------------------
class TaskTags extends Table {
  /// FK → Tasks.id — cascade delete when task is deleted.
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();

  /// FK → Tags.id — not cascade-deleted.
  TextColumn get tagId => text().references(Tags, #id)();

  /// Composite primary key prevents duplicate (task, tag) pairs.
  @override
  Set<Column> get primaryKey => {taskId, tagId};
}

// ---------------------------------------------------------------------------
// AppDatabase
// Wires all tables and DAOs together.
//
// Usage:
//   Production : AppDatabase(NativeDatabase.createInBackground(File('taskem.db')))
//   Tests      : AppDatabase(NativeDatabase.memory())
// ---------------------------------------------------------------------------
@DriftDatabase(
  tables: [Categories, TaskLists, Tags, Tasks, TaskTags],
  daos: [TaskDao, CategoryDao, TagDao, TaskListDao],
)
class AppDatabase extends _$AppDatabase {
  /// Primary constructor — accepts any QueryExecutor so the database can be
  /// opened from both production code and unit tests.
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Enable foreign key constraints before any table operations.
        // SQLite disables FK enforcement by default; this ensures ON DELETE
        // CASCADE rules on TaskTags are honoured.
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        // Version 1 — initial schema: create every table declared above.
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        // Placeholder for future schema migrations.
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations go here.
        },
      );
}
