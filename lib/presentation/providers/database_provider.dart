// lib/presentation/providers/database_provider.dart
//
// Provides the single AppDatabase instance for the entire app lifetime.

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:taskem/data/datasources/database/app_database.dart';

part 'database_provider.g.dart';

/// Provides the single [AppDatabase] instance.
///
/// keepAlive: true — lives for the entire app lifetime.
/// The database file is written to the current working directory.
/// In production this will be the app's data directory on Linux.
@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase(
    NativeDatabase.createInBackground(
      File('taskem.db'),
    ),
  );
}
