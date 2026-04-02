// test/unit/data/daos/category_dao_test.dart
//
// Integration tests for CategoryDao using an in-memory SQLite database.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:victor_todo/data/datasources/database/app_database.dart';
import '../../../helpers/sqlite_test_helper.dart';

void main() {
  setUpAll(initSqliteForTests);

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('CategoryDao', () {
    test('insertCategory persists a new category row', () async {
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          id: 'cat-1',
          name: 'Work',
          colour: '#FF5722',
        ),
      );

      final categories = await db.categoryDao.getAllCategories();
      expect(categories, hasLength(1));
      expect(categories.first.id, 'cat-1');
      expect(categories.first.name, 'Work');
      expect(categories.first.colour, '#FF5722');
    });

    test('getAllCategories returns all rows', () async {
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          id: 'cat-1',
          name: 'Work',
          colour: '#FF5722',
        ),
      );
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          id: 'cat-2',
          name: 'Personal',
          colour: '#2196F3',
        ),
      );

      final categories = await db.categoryDao.getAllCategories();
      expect(categories, hasLength(2));
    });

    test('getCategoryById returns the correct category', () async {
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          id: 'cat-x',
          name: 'Reading',
          colour: '#4CAF50',
        ),
      );

      final category = await db.categoryDao.getCategoryById('cat-x');
      expect(category, isNotNull);
      expect(category!.name, 'Reading');
    });

    test('getCategoryById returns null for unknown id', () async {
      final category = await db.categoryDao.getCategoryById('nonexistent');
      expect(category, isNull);
    });

    test('updateCategory modifies an existing row', () async {
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          id: 'cat-1',
          name: 'Old',
          colour: '#000000',
        ),
      );

      await db.categoryDao.updateCategory(
        const CategoriesCompanion(
          id: Value('cat-1'),
          name: Value('New Name'),
          colour: Value('#FFFFFF'),
        ),
      );

      final category = await db.categoryDao.getCategoryById('cat-1');
      expect(category!.name, 'New Name');
      expect(category.colour, '#FFFFFF');
    });

    test('deleteCategory removes the row', () async {
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(id: 'del', name: 'ToDelete', colour: '#aaa'),
      );
      await db.categoryDao.insertCategory(
        CategoriesCompanion.insert(
          id: 'keep',
          name: 'ToKeep',
          colour: '#bbb',
        ),
      );

      await db.categoryDao.deleteCategory('del');

      final categories = await db.categoryDao.getAllCategories();
      expect(categories, hasLength(1));
      expect(categories.first.id, 'keep');
    });
  });
}
