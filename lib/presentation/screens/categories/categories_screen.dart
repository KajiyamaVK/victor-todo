// lib/presentation/screens/categories/categories_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:taskem/domain/entities/category.dart';
import 'package:taskem/presentation/providers/category_providers.dart';

/// Categories screen — lists all categories and provides an add form.
///
/// Allows the user to create new categories with a name and colour.
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _nameController = TextEditingController();
  String _selectedColour = '#7C4DFF';

  static const _colours = [
    '#7C4DFF', // Purple
    '#FF7043', // Deep orange
    '#43A047', // Green
    '#FFB300', // Amber
    '#E53935', // Red
    '#1E88E5', // Blue
    '#00ACC1', // Cyan
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final category = Category(
      id: const Uuid().v4(),
      name: name,
      colour: _selectedColour,
    );

    await ref.read(addCategoryUseCaseProvider).execute(category);
    ref.invalidate(categoryListProvider);
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          // Add category form.
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category name',
                      hintText: 'e.g. Work',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Colour picker chips.
                SizedBox(
                  width: 120,
                  child: Wrap(
                    spacing: 4,
                    children: _colours.map((hex) {
                      final colour = Color(
                        int.parse(hex.replaceFirst('#', 'FF'), radix: 16),
                      );
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColour = hex),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: colour,
                          child: _selectedColour == hex
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Category list.
          Expanded(
            child: categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) =>
                  Center(child: Text('Error loading categories: $err')),
              data: (categories) {
                if (categories.isEmpty) {
                  return const Center(child: Text('No categories yet'));
                }
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final colour = Color(
                      int.parse(
                        cat.colour.replaceFirst('#', 'FF'),
                        radix: 16,
                      ),
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colour,
                        radius: 12,
                      ),
                      title: Text(cat.name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
