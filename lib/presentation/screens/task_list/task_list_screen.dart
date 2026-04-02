// lib/presentation/screens/task_list/task_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:victor_todo/core/constants/route_constants.dart';
import 'package:victor_todo/presentation/providers/task_providers.dart';
import 'package:victor_todo/presentation/widgets/empty_state.dart';
import 'package:victor_todo/presentation/widgets/task_tile.dart';

/// Task list screen — shows tasks filtered by a specific named list.
///
/// [listId] is required and should match a [TaskList.id] in the database.
class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({required this.listId, super.key});

  /// The id of the named list to filter by.
  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksByListNotifierProvider(listId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(
          child: Text('Error loading tasks: $err'),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return EmptyState(
              message: 'No tasks in this list',
              ctaLabel: 'Add a task',
              onCtaTap: () => context.push(RouteConstants.taskDetail),
            );
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskTile(task: tasks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () => context.push(RouteConstants.taskDetail),
        child: const Icon(Icons.add),
      ),
    );
  }
}
