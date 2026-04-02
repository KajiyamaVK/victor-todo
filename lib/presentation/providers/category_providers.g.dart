// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryRepositoryHash() =>
    r'42dc9a282081f958c7c5f191aa7dd4ba790c8e60';

/// Provides the concrete [CategoryRepository] backed by drift.
///
/// Copied from [categoryRepository].
@ProviderFor(categoryRepository)
final categoryRepositoryProvider =
    AutoDisposeProvider<CategoryRepository>.internal(
  categoryRepository,
  name: r'categoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryRepositoryRef = AutoDisposeProviderRef<CategoryRepository>;
String _$addCategoryUseCaseHash() =>
    r'8dd13d149969a57f22c0969f7ea379dc4aa25bab';

/// Provides [AddCategoryUseCase].
///
/// Copied from [addCategoryUseCase].
@ProviderFor(addCategoryUseCase)
final addCategoryUseCaseProvider =
    AutoDisposeProvider<AddCategoryUseCase>.internal(
  addCategoryUseCase,
  name: r'addCategoryUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addCategoryUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddCategoryUseCaseRef = AutoDisposeProviderRef<AddCategoryUseCase>;
String _$getCategoriesUseCaseHash() =>
    r'8c38372168a3697b474af2e152e1bff2d0614397';

/// Provides [GetCategoriesUseCase].
///
/// Copied from [getCategoriesUseCase].
@ProviderFor(getCategoriesUseCase)
final getCategoriesUseCaseProvider =
    AutoDisposeProvider<GetCategoriesUseCase>.internal(
  getCategoriesUseCase,
  name: r'getCategoriesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCategoriesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCategoriesUseCaseRef = AutoDisposeProviderRef<GetCategoriesUseCase>;
String _$categoryListHash() => r'd1f3a651b5687102283abd6a5f7f9b6259b11d82';

/// Shorthand provider for watching the category list as AsyncValue.
///
/// Copied from [categoryList].
@ProviderFor(categoryList)
final categoryListProvider = AutoDisposeFutureProvider<List<Category>>.internal(
  categoryList,
  name: r'categoryListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryListRef = AutoDisposeFutureProviderRef<List<Category>>;
String _$categoryListNotifierHash() =>
    r'1a8cfdae9837025704733d1c9418b457664c05dd';

/// AsyncNotifier that holds the full list of categories.
///
/// Copied from [CategoryListNotifier].
@ProviderFor(CategoryListNotifier)
final categoryListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CategoryListNotifier, List<Category>>.internal(
  CategoryListNotifier.new,
  name: r'categoryListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryListNotifier = AutoDisposeAsyncNotifier<List<Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
