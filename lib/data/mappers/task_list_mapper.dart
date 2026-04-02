// lib/data/mappers/task_list_mapper.dart
//
// Converts between drift TaskList (data class) and domain TaskList entities.
//
// NAMING NOTE: drift generates a data class called [TaskList].
// The domain entity is also [TaskList]. Aliased here:
//   - db.TaskList     = drift generated data class
//   - domain.TaskList = clean domain entity

import 'package:drift/drift.dart' show Value;

import 'package:victor_todo/data/datasources/database/app_database.dart' as db
    show TaskList, TaskListsCompanion;
import 'package:victor_todo/domain/entities/task_list.dart' as domain
    show TaskList;

/// Converts between drift [db.TaskList] and domain [domain.TaskList].
class TaskListMapper {
  const TaskListMapper._();

  /// Converts a drift [db.TaskList] row to a domain [domain.TaskList].
  static domain.TaskList toDomain(db.TaskList data) {
    return domain.TaskList(
      id: data.id,
      name: data.name,
      description: data.description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data.createdAt),
    );
  }

  /// Converts a domain [domain.TaskList] to a [TaskListsCompanion] for drift.
  static db.TaskListsCompanion toCompanion(domain.TaskList taskList) {
    return db.TaskListsCompanion(
      id: Value(taskList.id),
      name: Value(taskList.name),
      description: Value(taskList.description),
      createdAt: Value(taskList.createdAt.millisecondsSinceEpoch),
    );
  }
}
