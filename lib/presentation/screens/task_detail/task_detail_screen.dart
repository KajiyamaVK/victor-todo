// lib/presentation/screens/task_detail/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:taskem/domain/entities/priority.dart';
import 'package:taskem/domain/entities/task.dart';
import 'package:taskem/presentation/providers/category_providers.dart';
import 'package:taskem/presentation/providers/tag_providers.dart';
import 'package:taskem/presentation/providers/task_providers.dart';
import 'package:taskem/presentation/widgets/due_date_picker.dart';
import 'package:taskem/presentation/widgets/priority_badge.dart';
import 'package:taskem/presentation/widgets/tag_chip.dart';

/// Task detail screen — create a new task or edit an existing one.
///
/// When [taskId] is null, the screen is in create mode.
/// When [taskId] is provided, the screen loads the task and enters edit mode.
class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({this.taskId, super.key});

  /// The id of the task to edit. null for create mode.
  final String? taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Priority _priority = Priority.medium;
  DateTime? _dueDate;
  String? _categoryId;
  String? _taskListId;
  final Set<String> _selectedTagIds = {};

  bool _isLoading = false;
  bool _isEditMode = false;
  Task? _existingTask;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _isEditMode = true;
      _loadExistingTask();
    }
  }

  Future<void> _loadExistingTask() async {
    final repo = ref.read(taskRepositoryProvider);
    final task = await repo.getTaskById(widget.taskId!);
    if (task != null && mounted) {
      setState(() {
        _existingTask = task;
        _titleController.text = task.title;
        _descriptionController.text = task.description ?? '';
        _priority = task.priority;
        _dueDate = task.dueDate;
        _categoryId = task.categoryId;
        _taskListId = task.taskListId;
        _selectedTagIds.addAll(task.tagIds);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();

      if (_isEditMode && _existingTask != null) {
        // Update existing task.
        final updated = _existingTask!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          priority: _priority,
          dueDate: _dueDate,
          categoryId: _categoryId,
          taskListId: _taskListId,
          tagIds: _selectedTagIds.toList(),
          updatedAt: now,
          clearDueDate: _dueDate == null,
          clearDescription: _descriptionController.text.trim().isEmpty,
        );
        await ref.read(taskListNotifierProvider.notifier).updateTask(updated);
      } else {
        // Create new task.
        final task = Task(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          priority: _priority,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
          dueDate: _dueDate,
          categoryId: _categoryId,
          taskListId: _taskListId,
          tagIds: _selectedTagIds.toList(),
        );
        await ref.read(taskListNotifierProvider.notifier).addTask(task);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving task: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final tagsAsync = ref.watch(tagListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Task' : 'New Task'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field.
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'What needs to be done?',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Description field.
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional notes',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // Due date picker.
            DueDatePicker(
              dueDate: _dueDate,
              onDateSelected: (date) => setState(() => _dueDate = date),
            ),
            const SizedBox(height: 12),

            // Priority selector.
            _buildPrioritySelector(),
            const SizedBox(height: 12),

            // Category dropdown.
            categoriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (categories) {
                if (categories.isEmpty) return const SizedBox.shrink();
                return DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: _categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  hint: const Text('None'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...categories.map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                );
              },
            ),
            const SizedBox(height: 12),

            // Tags multi-select.
            tagsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (tags) {
                if (tags.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tags'),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: tags.map((tag) {
                        final selected = _selectedTagIds.contains(tag.id);
                        return FilterChip(
                          label: TagChip(label: tag.name),
                          selected: selected,
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                _selectedTagIds.add(tag.id);
                              } else {
                                _selectedTagIds.remove(tag.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: Priority.values.map((p) {
            return GestureDetector(
              onTap: () => setState(() => _priority = p),
              child: Opacity(
                opacity: _priority == p ? 1.0 : 0.4,
                child: PriorityBadge(priority: p),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
