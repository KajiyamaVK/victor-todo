// lib/presentation/widgets/tag_chip.dart

import 'package:flutter/material.dart';

import 'package:taskem/presentation/theme/app_theme.dart';

/// Small chip displaying a tag label.
///
/// Used in [TaskTile] to show the tags attached to a task.
class TagChip extends StatelessWidget {
  const TagChip({required this.label, super.key});

  /// The tag label to display.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryAccent.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryAccent.withAlpha(80)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}
