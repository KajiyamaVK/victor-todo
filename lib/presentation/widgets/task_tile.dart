// lib/presentation/widgets/task_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:victor_todo/core/constants/route_constants.dart';
import 'package:victor_todo/core/utils/date_utils.dart';
import 'package:victor_todo/domain/entities/task.dart';
import 'package:victor_todo/presentation/providers/task_providers.dart';
import 'package:victor_todo/presentation/theme/app_theme.dart';
import 'package:victor_todo/presentation/widgets/priority_badge.dart';

/// A list tile representing a single task.
///
/// Displays a checkbox, title, due date chip, and priority badge.
/// Tap opens the edit screen; long press shows a delete confirmation dialog.
class TaskTile extends ConsumerWidget {
  const TaskTile({required this.task, super.key});

  /// The task to display.
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppTheme.priorityUrgent,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        ref.read(taskListNotifierProvider.notifier).deleteTask(task.id);
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              ref.read(taskListNotifierProvider.notifier).completeTask(task.id);
            },
          ),
          title: Text(
            task.title,
            style: task.isCompleted
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.textSecondary,
                  )
                : null,
          ),
          subtitle: _buildSubtitle(context),
          trailing: PriorityBadge(priority: task.priority),
          onTap: () => context.push(
            '${RouteConstants.taskDetail}?taskId=${task.id}',
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final parts = <Widget>[];

    // Due date chip.
    if (task.dueDate != null) {
      final isOverdue =
          AppDateUtils.isOverdue(task.dueDate) && !task.isCompleted;
      parts.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isOverdue
                ? AppTheme.priorityUrgent.withAlpha(30)
                : AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: isOverdue
                    ? AppTheme.priorityUrgent
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                AppDateUtils.formatShortDate(task.dueDate),
                style: TextStyle(
                  fontSize: 11,
                  color: isOverdue
                      ? AppTheme.priorityUrgent
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (parts.isEmpty) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(spacing: 4, runSpacing: 4, children: parts),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
