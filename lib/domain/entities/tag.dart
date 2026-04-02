// lib/domain/entities/tag.dart
// Pure Dart — no Flutter, no drift imports.

/// Immutable domain entity representing a tag.
///
/// Tags are labels that can be applied to many tasks (many-to-many via TaskTags).
/// Equality is based on [id] only.
class Tag {
  /// Creates a [Tag] with all required fields.
  const Tag({
    required this.id,
    required this.name,
  });

  /// Unique identifier — UUID string generated before insert.
  final String id;

  /// Tag label — must be unique across all tags.
  final String name;

  /// Returns a copy of this tag with the specified fields replaced.
  Tag copyWith({
    String? id,
    String? name,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  /// Identity equality: two Tags with the same [id] are considered equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Tag && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Tag(id: $id, name: $name)';
}
