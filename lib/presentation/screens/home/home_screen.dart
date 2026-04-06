// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:taskem/core/constants/route_constants.dart';
import 'package:taskem/presentation/providers/task_providers.dart';
import 'package:taskem/presentation/widgets/empty_state.dart';
import 'package:taskem/presentation/widgets/task_tile.dart';

/// Home screen — displays all tasks in a single list.
///
/// Uses [taskListNotifierProvider] to watch the full task list.
/// Shows a loading spinner while tasks are loading, error text on failure,
/// and the task list (or an empty state) when data is available.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.label_outline),
            tooltip: 'Categories',
            onPressed: () => context.push(RouteConstants.categories),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(RouteConstants.settings),
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, __) => Center(
          child: Text(
            'Error loading tasks: $err',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.redAccent),
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return EmptyState(
              message: 'No tasks yet',
              ctaLabel: 'Add your first task',
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
