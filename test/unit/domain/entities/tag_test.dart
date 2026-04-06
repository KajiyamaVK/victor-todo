// test/unit/domain/entities/tag_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:taskem/domain/entities/tag.dart';

void main() {
  group('Tag entity', () {
    test('can be created with required fields', () {
      const tag = Tag(id: 'tag-1', name: 'flutter');

      expect(tag.id, 'tag-1');
      expect(tag.name, 'flutter');
    });

    test('copyWith creates a new instance with updated fields', () {
      const tag = Tag(id: 'tag-1', name: 'flutter');
      final updated = tag.copyWith(name: 'dart');

      expect(tag.name, 'flutter'); // Original unchanged.
      expect(updated.name, 'dart');
      expect(updated.id, 'tag-1'); // id unchanged
    });

    test('equality is based on id only', () {
      const tag1 = Tag(id: 'same-id', name: 'flutter');
      const tag2 = Tag(id: 'same-id', name: 'dart');
      const tag3 = Tag(id: 'other-id', name: 'flutter');

      expect(tag1, equals(tag2));
      expect(tag1, isNot(equals(tag3)));
    });

    test('hashCode is based on id', () {
      const tag1 = Tag(id: 'my-id', name: 'flutter');
      const tag2 = Tag(id: 'my-id', name: 'dart');

      expect(tag1.hashCode, equals(tag2.hashCode));
    });
  });
}
