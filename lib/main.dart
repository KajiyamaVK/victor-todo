// lib/main.dart
// Application entry point.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:victor_todo/presentation/router/app_router.dart';
import 'package:victor_todo/presentation/theme/app_theme.dart';

/// Global plugin instance — accessed by [NotificationService].
/// Declared here so the initialization is co-located with app startup.
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file.
  // The file is bundled as a Flutter asset (see pubspec.yaml assets section).
  await dotenv.load(fileName: '.env');

  // Initialise local notifications for Linux (uses libnotify).
  const initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open');
  const initializationSettings =
      InitializationSettings(linux: initializationSettingsLinux);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    // ProviderScope is the root of the Riverpod provider tree.
    const ProviderScope(child: VictorTodoApp()),
  );
}

/// Root application widget.
///
/// Configures the dark theme and app router.
class VictorTodoApp extends StatelessWidget {
  const VictorTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Victor Todo',
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
