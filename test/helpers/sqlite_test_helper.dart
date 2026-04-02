// test/helpers/sqlite_test_helper.dart
//
// Helper to initialise the sqlite3 library in test environments where the
// unversioned libsqlite3.so symlink is absent (common on Ubuntu without the
// -dev package).  Loads libsqlite3.so.0 instead.
//
// Call [initSqliteForTests] in main() or a setUpAll block before creating any
// AppDatabase(NativeDatabase.memory()) instance.

import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

/// Opens the system sqlite3 shared library using a platform-appropriate path.
///
/// On Linux the dev symlink (libsqlite3.so) may be absent; we fall back to
/// the versioned library (libsqlite3.so.0).
void initSqliteForTests() {
  if (!Platform.isLinux) return; // Only needed on Linux.

  open.overrideFor(OperatingSystem.linux, () {
    // Try the unversioned name first (present when libsqlite3-dev is installed).
    try {
      return DynamicLibrary.open('libsqlite3.so');
    } catch (_) {
      // Fall back to the versioned library that ships with the OS.
      return DynamicLibrary.open('libsqlite3.so.0');
    }
  });
}
