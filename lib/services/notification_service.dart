// lib/services/notification_service.dart
//
// Local notification scheduling for task reminders.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:victor_todo/main.dart';

part 'notification_service.g.dart';

/// Schedules and cancels local notifications for task reminders.
///
/// Takes primitive types (notificationId as int, title as String) —
/// no domain entity imports to keep this service loosely coupled.
///
/// On Linux, flutter_local_notifications uses libnotify.
/// Scheduled (future) notifications require the timezone package.
class NotificationService {
  const NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  /// Schedules a notification for [notificationId] at [scheduledDate].
  ///
  /// Currently only shows an immediate notification on Linux because
  /// scheduled (zoned) notifications require additional timezone setup.
  /// This is a v1 stub that can be promoted to full scheduling later.
  Future<void> scheduleReminder({
    required int notificationId,
    required String title,
    required DateTime scheduledDate,
  }) async {
    const linuxDetails = LinuxNotificationDetails();
    const details = NotificationDetails(linux: linuxDetails);

    // Show notification immediately as a stub for v1.
    // TODO(v2): Replace with zonedSchedule when full scheduling is needed.
    await _plugin.show(
      notificationId,
      title,
      'Reminder for your task',
      details,
    );
  }

  /// Cancels the notification with the given [notificationId].
  ///
  /// No-op if no notification exists for the given id.
  Future<void> cancelReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}

/// Provides the [NotificationService] instance.
///
/// Uses the global [flutterLocalNotificationsPlugin] that was initialised
/// in [main].
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService(flutterLocalNotificationsPlugin);
}
