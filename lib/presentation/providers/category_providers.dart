// lib/presentation/providers/category_providers.dart
//
// Riverpod providers for category-related use cases and state.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:victor_todo/data/repositories/category_repository_impl.dart';
import 'package:victor_todo/domain/entities/category.dart';
import 'package:victor_todo/domain/repositories/category_repository.dart';
import 'package:victor_todo/domain/usecases/category/add_category_use_case.dart';
import 'package:victor_todo/domain/usecases/category/get_categories_use_case.dart';
import 'database_provider.dart';

part 'category_providers.g.dart';

/// Provides the concrete [CategoryRepository] backed by drift.
@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final db = ref.watch(databaseProvider);
  return CategoryRepositoryImpl(db.categoryDao);
}

/// Provides [AddCategoryUseCase].
@riverpod
AddCategoryUseCase addCategoryUseCase(Ref ref) {
  return AddCategoryUseCase(ref.watch(categoryRepositoryProvider));
}

/// Provides [GetCategoriesUseCase].
@riverpod
GetCategoriesUseCase getCategoriesUseCase(Ref ref) {
  return GetCategoriesUseCase(ref.watch(categoryRepositoryProvider));
}

/// AsyncNotifier that holds the full list of categories.
@riverpod
class CategoryListNotifier extends _$CategoryListNotifier {
  @override
  Future<List<Category>> build() async {
    return ref.watch(getCategoriesUseCaseProvider).execute();
  }

  /// Adds a category and refreshes the list.
  Future<void> addCategory(Category category) async {
    await ref.read(addCategoryUseCaseProvider).execute(category);
    ref.invalidateSelf();
  }
}

/// Shorthand provider for watching the category list as AsyncValue.
@riverpod
Future<List<Category>> categoryList(Ref ref) async {
  return ref.watch(getCategoriesUseCaseProvider).execute();
}
