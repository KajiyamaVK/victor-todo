// lib/data/datasources/daos/category_dao.dart
//
// Data Access Object for the categories table.

// ignore: depend_on_referenced_packages
import 'package:drift/drift.dart';

import 'package:taskem/data/datasources/database/app_database.dart';

part 'category_dao.g.dart';

/// Data Access Object for the categories table.
///
/// Note: drift generates the data class as [Category].
/// The domain entity [Category] lives in a separate package and is
/// never imported in this file.
@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Returns all category rows.
  Future<List<Category>> getAllCategories() => select(categories).get();

  /// Returns the category row with the given [id], or null.
  Future<Category?> getCategoryById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  /// Inserts a new category row.
  Future<void> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  /// Updates an existing category row (matches by id).
  Future<void> updateCategory(CategoriesCompanion entry) =>
      (update(categories)..where((c) => c.id.equals(entry.id.value)))
          .write(entry);

  /// Deletes the category row with the given [id].
  Future<void> deleteCategory(String id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();
}
