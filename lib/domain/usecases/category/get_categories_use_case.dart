// lib/domain/usecases/category/get_categories_use_case.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/category.dart';
import 'package:victor_todo/domain/repositories/category_repository.dart';

/// Returns all categories.
class GetCategoriesUseCase {
  /// Creates a [GetCategoriesUseCase] with the given [repository].
  const GetCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  /// Fetches all categories from the repository.
  Future<List<Category>> execute() => _repository.getAllCategories();
}
