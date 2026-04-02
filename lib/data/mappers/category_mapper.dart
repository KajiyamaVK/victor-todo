// lib/data/mappers/category_mapper.dart
//
// Converts between drift Category (data class) and domain Category entities.
//
// NAMING NOTE: drift generates a data class called [Category].
// The domain entity is also [Category]. Aliased here:
//   - db.Category  = drift generated data class
//   - domain.Category = clean domain entity

import 'package:drift/drift.dart' show Value;

import 'package:victor_todo/data/datasources/database/app_database.dart' as db
    show Category, CategoriesCompanion;
import 'package:victor_todo/domain/entities/category.dart' as domain
    show Category;

/// Converts between drift [db.Category] and domain [domain.Category].
class CategoryMapper {
  const CategoryMapper._();

  /// Converts a drift [db.Category] row to a domain [domain.Category].
  static domain.Category toDomain(db.Category data) {
    return domain.Category(
      id: data.id,
      name: data.name,
      colour: data.colour,
    );
  }

  /// Converts a domain [domain.Category] to a [CategoriesCompanion] for drift.
  static db.CategoriesCompanion toCompanion(domain.Category category) {
    return db.CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      colour: Value(category.colour),
    );
  }
}
