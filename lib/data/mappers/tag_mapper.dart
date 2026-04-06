// lib/data/mappers/tag_mapper.dart
//
// Converts between drift Tag (data class) and domain Tag entities.
//
// NAMING NOTE: drift generates a data class called [Tag].
// The domain entity is also [Tag]. Aliased here:
//   - db.Tag     = drift generated data class
//   - domain.Tag = clean domain entity

import 'package:drift/drift.dart' show Value;

import 'package:taskem/data/datasources/database/app_database.dart' as db
    show Tag, TagsCompanion;
import 'package:taskem/domain/entities/tag.dart' as domain show Tag;

/// Converts between drift [db.Tag] and domain [domain.Tag].
class TagMapper {
  const TagMapper._();

  /// Converts a drift [db.Tag] row to a domain [domain.Tag].
  static domain.Tag toDomain(db.Tag data) {
    return domain.Tag(
      id: data.id,
      name: data.name,
    );
  }

  /// Converts a domain [domain.Tag] to a [TagsCompanion] for drift.
  static db.TagsCompanion toCompanion(domain.Tag tag) {
    return db.TagsCompanion(
      id: Value(tag.id),
      name: Value(tag.name),
    );
  }
}
