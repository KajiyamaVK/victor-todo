// lib/domain/entities/task.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:taskem/domain/entities/priority.dart';

/// Immutable domain entity representing a single task.
///
/// All fields are final. Use [copyWith] for updates.
/// Equality is based on [id] only, so two Task instances with the same id
/// are considered equal regardless of other fields.
class Task {
  /// Creates a [Task] with all required fields.
  const Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.dueDate,
    this.reminderAt,
    this.completedAt,
    this.categoryId,
    this.taskListId,
    this.tagIds = const [],
  });

  /// Unique identifier — UUID string generated before insert.
  final String id;

  /// Short title of the task, required.
  final String title;

  /// Optional long-form description.
  final String? description;

  /// Optional due date. Stored as Unix ms timestamp in the database.
  final DateTime? dueDate;

  /// Optional reminder time for local notification scheduling.
  final DateTime? reminderAt;

  /// Priority level of this task.
  final Priority priority;

  /// Whether the task has been completed.
  final bool isCompleted;

  /// Set when the task is marked complete; null if not done.
  final DateTime? completedAt;

  /// FK to Category (optional). null means uncategorised.
  final String? categoryId;

  /// FK to TaskList (optional). null means the task is in "All Tasks" only.
  final String? taskListId;

  /// IDs of all tags attached to this task (many-to-many via TaskTags table).
  final List<String> tagIds;

  /// Timestamp of creation — set once and never changed.
  final DateTime createdAt;

  /// Timestamp of last modification — updated on every write.
  final DateTime updatedAt;

  /// Returns a copy of this task with the specified fields replaced.
  ///
  /// All parameters are optional; omitted ones keep the current value.
  /// To clear a nullable field, pass `null` explicitly.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? reminderAt,
    Priority? priority,
    bool? isCompleted,
    DateTime? completedAt,
    String? categoryId,
    String? taskListId,
    List<String>? tagIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Sentinel values for explicitly clearing nullable fields.
    bool clearDescription = false,
    bool clearDueDate = false,
    bool clearReminderAt = false,
    bool clearCompletedAt = false,
    bool clearCategoryId = false,
    bool clearTaskListId = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      reminderAt: clearReminderAt ? null : (reminderAt ?? this.reminderAt),
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      taskListId: clearTaskListId ? null : (taskListId ?? this.taskListId),
      tagIds: tagIds ?? this.tagIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Identity equality: two Tasks with the same [id] are considered equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Task && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Task(id: $id, title: $title, priority: $priority, '
      'isCompleted: $isCompleted)';
}
