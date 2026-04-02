// lib/core/utils/date_utils.dart
//
// Date/time utility functions used across the presentation layer.
// No domain imports — safe to use anywhere.

import 'package:intl/intl.dart';

/// Utility class for date formatting and calculations.
///
/// All methods are static; this class is not instantiated.
class AppDateUtils {
  // Private constructor prevents instantiation.
  const AppDateUtils._();

  /// Formats [date] as a human-readable short date, e.g. "Dec 31, 2025".
  ///
  /// Returns an empty string if [date] is null.
  static String formatShortDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat.yMMMd().format(date);
  }

  /// Formats [date] as a full datetime, e.g. "Dec 31, 2025 10:30 AM".
  ///
  /// Returns an empty string if [date] is null.
  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat.yMMMd().add_jm().format(date);
  }

  /// Returns true if [date] is today (ignoring time-of-day).
  static bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  /// Returns true if [date] is before today (task is overdue).
  ///
  /// Returns false if [date] is null.
  static bool isOverdue(DateTime? date) {
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }
}
