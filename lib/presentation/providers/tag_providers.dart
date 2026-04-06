// lib/presentation/providers/tag_providers.dart
//
// Riverpod providers for tag-related use cases and state.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:taskem/data/repositories/tag_repository_impl.dart';
import 'package:taskem/domain/entities/tag.dart';
import 'package:taskem/domain/repositories/tag_repository.dart';
import 'package:taskem/domain/usecases/tag/add_tag_use_case.dart';
import 'package:taskem/domain/usecases/tag/get_tags_use_case.dart';
import 'database_provider.dart';

part 'tag_providers.g.dart';

/// Provides the concrete [TagRepository] backed by drift.
@riverpod
TagRepository tagRepository(Ref ref) {
  final db = ref.watch(databaseProvider);
  return TagRepositoryImpl(db.tagDao);
}

/// Provides [AddTagUseCase].
@riverpod
AddTagUseCase addTagUseCase(Ref ref) {
  return AddTagUseCase(ref.watch(tagRepositoryProvider));
}

/// Provides [GetTagsUseCase].
@riverpod
GetTagsUseCase getTagsUseCase(Ref ref) {
  return GetTagsUseCase(ref.watch(tagRepositoryProvider));
}

/// AsyncNotifier that holds the full list of tags.
@riverpod
class TagListNotifier extends _$TagListNotifier {
  @override
  Future<List<Tag>> build() async {
    return ref.watch(getTagsUseCaseProvider).execute();
  }

  /// Adds a tag and refreshes the list.
  Future<void> addTag(Tag tag) async {
    await ref.read(addTagUseCaseProvider).execute(tag);
    ref.invalidateSelf();
  }
}

/// Shorthand provider for watching the tag list as AsyncValue.
@riverpod
Future<List<Tag>> tagList(Ref ref) async {
  return ref.watch(getTagsUseCaseProvider).execute();
}
