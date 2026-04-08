// test/widget/screens/task_detail_screen_test.dart
//
// Widget tests for [TaskDetailScreen].

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskem/core/constants/app_constants.dart';
import 'package:taskem/presentation/providers/category_providers.dart';
import 'package:taskem/presentation/providers/tag_providers.dart';
import 'package:taskem/presentation/providers/task_providers.dart';
import 'package:taskem/presentation/screens/task_detail/task_detail_screen.dart';
import 'package:taskem/presentation/theme/app_theme.dart';

import '../../helpers/fake_category_repository.dart';
import '../../helpers/fake_tag_repository.dart';
import '../../helpers/fake_task_repository.dart';

// ---------------------------------------------------------------------------
// Test helper
// ---------------------------------------------------------------------------

/// Builds a [TaskDetailScreen] in create mode, with all repositories faked
/// so no real database is needed.
Widget _buildTestApp() {
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWith((ref) => FakeTaskRepository()),
      categoryRepositoryProvider.overrideWith((ref) => FakeCategoryRepository()),
      tagRepositoryProvider.overrideWith((ref) => FakeTagRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const TaskDetailScreen(),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TaskDetailScreen', () {
    testWidgets('form body wraps content in ConstrainedBox(800)', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pump();

      final boxes =
          tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      expect(
        boxes.any(
            (b) => b.constraints.maxWidth == AppConstants.kContentMaxWidth),
        isTrue,
        reason:
            'Expected a ConstrainedBox with maxWidth 800 in the form body',
      );
    });
  });
}
