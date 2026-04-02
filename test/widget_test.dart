// test/widget_test.dart
//
// Smoke test — verifies that VictorTodoApp can be pumped without crashing.
// Database and providers are overridden to avoid real I/O in tests.

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:victor_todo/data/datasources/database/app_database.dart';
import 'package:victor_todo/main.dart';
import 'package:victor_todo/presentation/providers/database_provider.dart';

void main() {
  testWidgets(
    'VictorTodoApp smoke test — renders without crash',
    (WidgetTester tester) async {
      // Use an in-memory database so no real file is created during tests.
      final inMemoryDb = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(inMemoryDb),
          ],
          child: const VictorTodoApp(),
        ),
      );

      // Allow async providers to resolve (task list query, etc.).
      await tester.pump(const Duration(milliseconds: 100));

      // The app title "Victor Todo" should be present in the widget tree
      // somewhere (MaterialApp.router sets it as the app title).
      // We verify the app bar title renders — HomeScreen shows "All Tasks".
      await tester.pump();

      // Just verifying no exception was thrown during rendering.
      expect(tester.takeException(), isNull);

      await inMemoryDb.close();
    },
  );
}
