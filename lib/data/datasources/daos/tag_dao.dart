// lib/data/datasources/daos/tag_dao.dart
//
// Data Access Object for the tags table.

// ignore: depend_on_referenced_packages
import 'package:drift/drift.dart';

import 'package:victor_todo/data/datasources/database/app_database.dart';

part 'tag_dao.g.dart';

/// Data Access Object for the tags table.
///
/// Note: drift generates the data class as [Tag].
@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  /// Returns all tag rows.
  Future<List<Tag>> getAllTags() => select(tags).get();

  /// Returns the tag row with the given [id], or null.
  Future<Tag?> getTagById(String id) =>
      (select(tags)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts a new tag row.
  Future<void> insertTag(TagsCompanion entry) => into(tags).insert(entry);

  /// Deletes the tag row with the given [id].
  Future<void> deleteTag(String id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();
}
