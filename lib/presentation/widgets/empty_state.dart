// lib/presentation/widgets/empty_state.dart

import 'package:flutter/material.dart';

import 'package:taskem/presentation/theme/app_theme.dart';

/// Centred empty-state widget shown when a list has no items.
///
/// Displays an icon, a message, and an optional call-to-action button.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message,
    required this.ctaLabel,
    required this.onCtaTap,
    super.key,
  });

  /// Primary message text, e.g. "No tasks yet".
  final String message;

  /// Label for the call-to-action button.
  final String ctaLabel;

  /// Callback invoked when the CTA button is tapped.
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 72,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onCtaTap,
            child: Text(ctaLabel),
          ),
        ],
      ),
    );
  }
}
