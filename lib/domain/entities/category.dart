// lib/domain/entities/category.dart
// Pure Dart — no Flutter, no drift imports.

/// Immutable domain entity representing a task category.
///
/// Categories group tasks by topic (e.g., "Work", "Personal").
/// Equality is based on [id] only.
class Category {
  /// Creates a [Category] with all required fields.
  const Category({
    required this.id,
    required this.name,
    required this.colour,
  });

  /// Unique identifier — UUID string generated before insert.
  final String id;

  /// Human-readable category name — must be unique across all categories.
  final String name;

  /// Colour expressed as a hex string, e.g. "#FF5722".
  final String colour;

  /// Returns a copy of this category with the specified fields replaced.
  Category copyWith({
    String? id,
    String? name,
    String? colour,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colour: colour ?? this.colour,
    );
  }

  /// Identity equality: two Categories with the same [id] are considered equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Category(id: $id, name: $name, colour: $colour)';
}
