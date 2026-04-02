// lib/domain/entities/task_list.dart
// Pure Dart — no Flutter, no drift imports.

/// Immutable domain entity representing a named task list.
///
/// Named lists group tasks (e.g., "Shopping", "Work Projects").
/// "All Tasks" is a UI concept only — it has no corresponding entity.
/// Equality is based on [id] only.
class TaskList {
  /// Creates a [TaskList] with all required fields.
  const TaskList({
    required this.id,
    required this.name,
    required this.createdAt,
    this.description,
  });

  /// Unique identifier — UUID string generated before insert.
  final String id;

  /// Human-readable list name — must be unique across all lists.
  final String name;

  /// Optional free-form description for the list.
  final String? description;

  /// Timestamp of creation — set once and never changed.
  final DateTime createdAt;

  /// Returns a copy of this task list with the specified fields replaced.
  TaskList copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    bool clearDescription = false,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Identity equality: two TaskLists with the same [id] are considered equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TaskList && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TaskList(id: $id, name: $name)';
}
