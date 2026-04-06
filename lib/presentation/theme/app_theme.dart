// lib/presentation/theme/app_theme.dart

import 'package:flutter/material.dart';

/// Victor-todo dark colour palette and ThemeData.
///
/// All colour constants are defined here. Never use raw hex values in widgets.
/// Reference these constants throughout the presentation layer for consistency.
class AppTheme {
  // ---------------------------------------------------------------------------
  // Colour palette
  // ---------------------------------------------------------------------------

  /// Background for the main scaffold surface.
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface colour for cards and elevated areas.
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Primary accent — deep purple for buttons, highlights, FAB.
  static const Color primaryAccent = Color(0xFF7C4DFF);

  /// Text/icon colour on primary-coloured backgrounds.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Primary text colour for titles and body text.
  static const Color textPrimary = Color(0xFFE0E0E0);

  /// Secondary text colour for subtitles and hints.
  static const Color textSecondary = Color(0xFF9E9E9E);

  // Priority badge colours.
  /// Urgent priority — red.
  static const Color priorityUrgent = Color(0xFFE53935);

  /// High priority — deep orange.
  static const Color priorityHigh = Color(0xFFFF7043);

  /// Medium priority — amber.
  static const Color priorityMedium = Color(0xFFFFB300);

  /// Low priority — green.
  static const Color priorityLow = Color(0xFF43A047);

  // ---------------------------------------------------------------------------
  // ThemeData
  // ---------------------------------------------------------------------------

  /// Dark theme with the custom taskem colour palette applied.
  static ThemeData get dark => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundDark,
        colorScheme: const ColorScheme.dark(
          surface: surfaceDark,
          primary: primaryAccent,
          onPrimary: onPrimary,
          secondary: primaryAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: textPrimary,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: surfaceDark,
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryAccent,
          foregroundColor: onPrimary,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: textPrimary,
          iconColor: textSecondary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textPrimary),
          bodySmall: TextStyle(color: textSecondary),
          titleLarge: TextStyle(color: textPrimary),
          titleMedium: TextStyle(color: textPrimary),
          titleSmall: TextStyle(color: textSecondary),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF2C2C2C),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryAccent),
          ),
          labelStyle: const TextStyle(color: textSecondary),
          hintStyle: const TextStyle(color: textSecondary),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryAccent;
            }
            return null;
          }),
        ),
      );
}
