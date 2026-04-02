// lib/domain/usecases/category/add_category_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/category.dart';
import 'package:victor_todo/domain/repositories/category_repository.dart';

/// Adds a new category to the repository after validating business rules.
///
/// Business rule: category name must not be empty.
class AddCategoryUseCase {
  /// Creates an [AddCategoryUseCase] with the given [repository].
  const AddCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  /// Validates [category] and adds it to the repository.
  ///
  /// Throws [ArgumentError] if the category name is empty.
  Future<void> execute(Category category) {
    if (category.name.trim().isEmpty) {
      throw ArgumentError.value(
        category.name,
        'name',
        'Category name must not be empty.',
      );
    }
    return _repository.addCategory(category);
  }
}
