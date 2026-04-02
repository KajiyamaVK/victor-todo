// lib/data/repositories/tag_repository_impl.dart
//
// Concrete implementation of TagRepository using drift DAO.

import 'package:victor_todo/data/datasources/daos/tag_dao.dart';
import 'package:victor_todo/data/mappers/tag_mapper.dart';
import 'package:victor_todo/domain/entities/tag.dart' as domain show Tag;
import 'package:victor_todo/domain/repositories/tag_repository.dart';

/// Concrete implementation of [TagRepository] using [TagDao].
class TagRepositoryImpl implements TagRepository {
  const TagRepositoryImpl(this._tagDao);

  final TagDao _tagDao;

  @override
  Future<List<domain.Tag>> getAllTags() async {
    final rows = await _tagDao.getAllTags();
    return rows.map(TagMapper.toDomain).toList();
  }

  @override
  Future<domain.Tag?> getTagById(String id) async {
    final row = await _tagDao.getTagById(id);
    return row != null ? TagMapper.toDomain(row) : null;
  }

  @override
  Future<void> addTag(domain.Tag tag) =>
      _tagDao.insertTag(TagMapper.toCompanion(tag));

  @override
  Future<void> deleteTag(String id) => _tagDao.deleteTag(id);
}
