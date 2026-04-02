// lib/presentation/widgets/due_date_picker.dart

import 'package:flutter/material.dart';

import 'package:victor_todo/core/utils/date_utils.dart';

/// A button widget that opens a date picker and displays the selected due date.
///
/// Calls [onDateSelected] when the user picks a date.
/// If [dueDate] is null, shows a placeholder string.
class DueDatePicker extends StatelessWidget {
  const DueDatePicker({
    required this.onDateSelected,
    this.dueDate,
    super.key,
  });

  /// The currently selected due date, or null if none.
  final DateTime? dueDate;

  /// Callback invoked with the new date when the user selects one.
  /// Called with null when the user clears the date.
  final void Function(DateTime?) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today_outlined, size: 16),
            label: Text(
              dueDate != null
                  ? AppDateUtils.formatShortDate(dueDate)
                  : 'Set due date',
            ),
            onPressed: () => _pickDate(context),
          ),
        ),
        if (dueDate != null)
          IconButton(
            icon: const Icon(Icons.clear, size: 18),
            tooltip: 'Clear due date',
            onPressed: () => onDateSelected(null),
          ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
