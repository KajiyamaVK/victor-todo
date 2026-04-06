// lib/presentation/widgets/priority_badge.dart

import 'package:flutter/material.dart';

import 'package:taskem/domain/entities/priority.dart';
import 'package:taskem/presentation/theme/app_theme.dart';

/// Small coloured badge displaying a task's priority level.
///
/// Uses colours defined in [AppTheme] — no raw hex values here.
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({required this.priority, super.key});

  /// The priority level to display.
  final Priority priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _colourFor(priority).withAlpha(30),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _colourFor(priority), width: 1),
      ),
      child: Text(
        _labelFor(priority),
        style: TextStyle(
          fontSize: 11,
          color: _colourFor(priority),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Returns the theme colour for the given [priority].
  static Color _colourFor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return AppTheme.priorityUrgent;
      case Priority.high:
        return AppTheme.priorityHigh;
      case Priority.medium:
        return AppTheme.priorityMedium;
      case Priority.low:
        return AppTheme.priorityLow;
    }
  }

  /// Returns the display label for the given [priority].
  static String _labelFor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return 'URGENT';
      case Priority.high:
        return 'HIGH';
      case Priority.medium:
        return 'MEDIUM';
      case Priority.low:
        return 'LOW';
    }
  }
}
