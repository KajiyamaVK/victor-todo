// lib/data/repositories/category_repository_impl.dart
//
// Concrete implementation of CategoryRepository using drift DAO.

import 'package:victor_todo/data/datasources/daos/category_dao.dart';
import 'package:victor_todo/data/mappers/category_mapper.dart';
import 'package:victor_todo/domain/entities/category.dart' as domain
    show Category;
import 'package:victor_todo/domain/repositories/category_repository.dart';

/// Concrete implementation of [CategoryRepository] using [CategoryDao].
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._categoryDao);

  final CategoryDao _categoryDao;

  @override
  Future<List<domain.Category>> getAllCategories() async {
    final rows = await _categoryDao.getAllCategories();
    return rows.map(CategoryMapper.toDomain).toList();
  }

  @override
  Future<domain.Category?> getCategoryById(String id) async {
    final row = await _categoryDao.getCategoryById(id);
    return row != null ? CategoryMapper.toDomain(row) : null;
  }

  @override
  Future<void> addCategory(domain.Category category) =>
      _categoryDao.insertCategory(CategoryMapper.toCompanion(category));

  @override
  Future<void> updateCategory(domain.Category category) =>
      _categoryDao.updateCategory(CategoryMapper.toCompanion(category));

  @override
  Future<void> deleteCategory(String id) => _categoryDao.deleteCategory(id);
}
