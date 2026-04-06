// lib/data/mappers/task_mapper.dart
//
// Converts between drift Task (data class) and domain Task entities.
// Pure functions — no state, not instantiated.
//
// NAMING NOTE: drift generates a data class called [Task] in app_database.g.dart.
// The domain entity is also called [Task] in domain/entities/task.dart.
// This file imports both with aliases to distinguish them:
//   - DriftTask  = drift generated data class (from app_database.dart)
//   - DomainTask = clean domain entity (from domain/entities/task.dart)

import 'package:drift/drift.dart' show Value;

import 'package:taskem/data/datasources/database/app_database.dart' as db
    show Task, TasksCompanion;
import 'package:taskem/domain/entities/priority.dart';
import 'package:taskem/domain/entities/task.dart' as domain show Task;

/// Converts between the drift-generated [db.Task] data class and the
/// domain [domain.Task] entity.
///
/// The drift data class is aliased as [db.Task] and the domain entity
/// as [domain.Task] to avoid naming collisions within this file.
class TaskMapper {
  // Private constructor — this class is never instantiated.
  const TaskMapper._();

  // ---------------------------------------------------------------------------
  // toDomain
  // ---------------------------------------------------------------------------

  /// Converts a drift [db.Task] row + [tagIds] list to a domain [domain.Task].
  ///
  /// [tagIds] is passed separately because the join-table query is performed
  /// by the repository, not the DAO.
  static domain.Task toDomain(db.Task data, List<String> tagIds) {
    return domain.Task(
      id: data.id,
      title: data.title,
      description: data.description,
      dueDate: data.dueDate != null
          ? DateTime.fromMillisecondsSinceEpoch(data.dueDate!)
          : null,
      reminderAt: data.reminderTime != null
          ? DateTime.fromMillisecondsSinceEpoch(data.reminderTime!)
          : null,
      priority: _priorityFromString(data.priority),
      isCompleted: data.isCompleted,
      completedAt: data.completedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(data.completedAt!)
          : null,
      categoryId: data.categoryId,
      taskListId: data.taskListId,
      tagIds: tagIds,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }

  // ---------------------------------------------------------------------------
  // toCompanion
  // ---------------------------------------------------------------------------

  /// Converts a domain [domain.Task] to a [TasksCompanion] for drift
  /// insert/update.
  static db.TasksCompanion toCompanion(domain.Task task) {
    return db.TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      dueDate: Value(task.dueDate?.millisecondsSinceEpoch),
      reminderTime: Value(task.reminderAt?.millisecondsSinceEpoch),
      priority: Value(_priorityToString(task.priority)),
      isCompleted: Value(task.isCompleted),
      completedAt: Value(task.completedAt?.millisecondsSinceEpoch),
      categoryId: Value(task.categoryId),
      taskListId: Value(task.taskListId),
      createdAt: Value(task.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(task.updatedAt.millisecondsSinceEpoch),
    );
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Converts a priority string (stored in SQLite) to a [Priority] enum value.
  ///
  /// Defaults to [Priority.medium] for unrecognised values — prevents crashes
  /// if the database ever contains an unexpected string.
  static Priority _priorityFromString(String value) {
    switch (value) {
      case 'low':
        return Priority.low;
      case 'high':
        return Priority.high;
      case 'urgent':
        return Priority.urgent;
      case 'medium':
      default:
        return Priority.medium;
    }
  }

  /// Converts a [Priority] enum value to the string stored in SQLite.
  static String _priorityToString(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'low';
      case Priority.medium:
        return 'medium';
      case Priority.high:
        return 'high';
      case Priority.urgent:
        return 'urgent';
    }
  }
}
