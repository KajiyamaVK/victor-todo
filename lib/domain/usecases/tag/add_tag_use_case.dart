// lib/domain/usecases/tag/add_tag_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/tag.dart';
import 'package:victor_todo/domain/repositories/tag_repository.dart';

/// Adds a new tag to the repository after validating business rules.
///
/// Business rule: tag name must not be empty.
class AddTagUseCase {
  /// Creates an [AddTagUseCase] with the given [repository].
  const AddTagUseCase(this._repository);

  final TagRepository _repository;

  /// Validates [tag] and adds it to the repository.
  ///
  /// Throws [ArgumentError] if the tag name is empty.
  Future<void> execute(Tag tag) {
    if (tag.name.trim().isEmpty) {
      throw ArgumentError.value(
        tag.name,
        'name',
        'Tag name must not be empty.',
      );
    }
    return _repository.addTag(tag);
  }
}
