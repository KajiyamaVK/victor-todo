// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagRepositoryHash() => r'6b4c3a57065f3534c40388d6540ab4befcc25c90';

/// Provides the concrete [TagRepository] backed by drift.
///
/// Copied from [tagRepository].
@ProviderFor(tagRepository)
final tagRepositoryProvider = AutoDisposeProvider<TagRepository>.internal(
  tagRepository,
  name: r'tagRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagRepositoryRef = AutoDisposeProviderRef<TagRepository>;
String _$addTagUseCaseHash() => r'b74a43d488e3cbe760dd4c708fe2e237f8335f64';

/// Provides [AddTagUseCase].
///
/// Copied from [addTagUseCase].
@ProviderFor(addTagUseCase)
final addTagUseCaseProvider = AutoDisposeProvider<AddTagUseCase>.internal(
  addTagUseCase,
  name: r'addTagUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addTagUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddTagUseCaseRef = AutoDisposeProviderRef<AddTagUseCase>;
String _$getTagsUseCaseHash() => r'b705c772f5e00b1ea15314ac4b02d9b87d135b49';

/// Provides [GetTagsUseCase].
///
/// Copied from [getTagsUseCase].
@ProviderFor(getTagsUseCase)
final getTagsUseCaseProvider = AutoDisposeProvider<GetTagsUseCase>.internal(
  getTagsUseCase,
  name: r'getTagsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTagsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTagsUseCaseRef = AutoDisposeProviderRef<GetTagsUseCase>;
String _$tagListHash() => r'88efde6b12e438a5b91661c04048043221d99d79';

/// Shorthand provider for watching the tag list as AsyncValue.
///
/// Copied from [tagList].
@ProviderFor(tagList)
final tagListProvider = AutoDisposeFutureProvider<List<Tag>>.internal(
  tagList,
  name: r'tagListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tagListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagListRef = AutoDisposeFutureProviderRef<List<Tag>>;
String _$tagListNotifierHash() => r'cc4135f0f2859b108ac393fe464bba0e13c87e6f';

/// AsyncNotifier that holds the full list of tags.
///
/// Copied from [TagListNotifier].
@ProviderFor(TagListNotifier)
final tagListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TagListNotifier, List<Tag>>.internal(
  TagListNotifier.new,
  name: r'tagListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TagListNotifier = AutoDisposeAsyncNotifier<List<Tag>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
