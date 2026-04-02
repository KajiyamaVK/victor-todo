// test/helpers/fake_tag_repository.dart
//
// In-memory fake implementation of [TagRepository] for use in unit tests.

import 'package:victor_todo/domain/entities/tag.dart';
import 'package:victor_todo/domain/repositories/tag_repository.dart';

/// In-memory fake implementation of [TagRepository].
class FakeTagRepository implements TagRepository {
  /// The backing store — tests can inspect or seed this directly.
  final List<Tag> tags = [];

  @override
  Future<List<Tag>> getAllTags() async => List<Tag>.from(tags);

  @override
  Future<Tag?> getTagById(String id) async {
    try {
      return tags.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addTag(Tag tag) async {
    tags.add(tag);
  }

  @override
  Future<void> deleteTag(String id) async {
    tags.removeWhere((t) => t.id == id);
  }
}
