// lib/domain/repositories/category_repository.dart
// Pure Dart — no Flutter, no drift imports.

import 'package:victor_todo/domain/entities/category.dart';

/// Abstract interface for category persistence.
///
/// Implemented by [CategoryRepositoryImpl] in the data layer.
abstract class CategoryRepository {
  /// Returns all categories.
  Future<List<Category>> getAllCategories();

  /// Returns the category with the given [id], or null if not found.
  Future<Category?> getCategoryById(String id);

  /// Inserts a new category.
  Future<void> addCategory(Category category);

  /// Updates an existing category.
  Future<void> updateCategory(Category category);

  /// Deletes the category with the given [id].
  Future<void> deleteCategory(String id);
}
