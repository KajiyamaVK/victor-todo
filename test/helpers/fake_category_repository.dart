// test/helpers/fake_category_repository.dart
//
// In-memory fake implementation of [CategoryRepository] for use in unit tests.

import 'package:taskem/domain/entities/category.dart';
import 'package:taskem/domain/repositories/category_repository.dart';

/// In-memory fake implementation of [CategoryRepository].
class FakeCategoryRepository implements CategoryRepository {
  /// The backing store — tests can inspect or seed this directly.
  final List<Category> categories = [];

  @override
  Future<List<Category>> getAllCategories() async =>
      List<Category>.from(categories);

  @override
  Future<Category?> getCategoryById(String id) async {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    categories.add(category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    categories.removeWhere((c) => c.id == id);
  }
}
