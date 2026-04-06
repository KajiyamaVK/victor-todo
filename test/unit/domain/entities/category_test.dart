// test/unit/domain/entities/category_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:taskem/domain/entities/category.dart';

void main() {
  group('Category entity', () {
    test('can be created with required fields', () {
      const cat = Category(id: 'cat-1', name: 'Work', colour: '#FF5722');

      expect(cat.id, 'cat-1');
      expect(cat.name, 'Work');
      expect(cat.colour, '#FF5722');
    });

    test('copyWith creates a new instance with updated fields', () {
      const cat = Category(id: 'cat-1', name: 'Work', colour: '#FF5722');
      final updated = cat.copyWith(name: 'Personal');

      expect(cat.name, 'Work'); // Original unchanged.
      expect(updated.name, 'Personal');
      expect(updated.id, 'cat-1'); // id unchanged
      expect(updated.colour, '#FF5722'); // colour unchanged
    });

    test('equality is based on id only', () {
      const cat1 = Category(id: 'same-id', name: 'Work', colour: '#FF5722');
      const cat2 = Category(id: 'same-id', name: 'Personal', colour: '#000000');
      const cat3 = Category(id: 'other-id', name: 'Work', colour: '#FF5722');

      expect(cat1, equals(cat2));
      expect(cat1, isNot(equals(cat3)));
    });

    test('hashCode is based on id', () {
      const cat1 = Category(id: 'my-id', name: 'Work', colour: '#FF5722');
      const cat2 = Category(id: 'my-id', name: 'Personal', colour: '#000000');

      expect(cat1.hashCode, equals(cat2.hashCode));
    });
  });
}
