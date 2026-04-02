// lib/domain/repositories/tag_repository.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/tag.dart';

/// Abstract interface for tag persistence.
///
/// Implemented by [TagRepositoryImpl] in the data layer.
abstract class TagRepository {
  /// Returns all tags.
  Future<List<Tag>> getAllTags();

  /// Returns the tag with the given [id], or null if not found.
  Future<Tag?> getTagById(String id);

  /// Inserts a new tag.
  Future<void> addTag(Tag tag);

  /// Deletes the tag with the given [id].
  Future<void> deleteTag(String id);
}
