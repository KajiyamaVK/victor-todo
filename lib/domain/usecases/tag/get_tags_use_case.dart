// lib/domain/usecases/tag/get_tags_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/tag.dart';
import 'package:victor_todo/domain/repositories/tag_repository.dart';

/// Returns all tags.
class GetTagsUseCase {
  /// Creates a [GetTagsUseCase] with the given [repository].
  const GetTagsUseCase(this._repository);

  final TagRepository _repository;

  /// Fetches all tags from the repository.
  Future<List<Tag>> execute() => _repository.getAllTags();
}
