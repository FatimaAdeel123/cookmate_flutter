import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../models/recipe.dart';
import '../widgets/app_shell.dart';
import '../widgets/recipe_card.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String _query = '';
  RecipeCategory? _category;
  Difficulty? _difficulty;

  List<Recipe> get _filtered {
    final query = _query.trim().toLowerCase();
    return recipes.where((recipe) {
      final text =
          '${recipe.title} ${recipe.description} ${recipe.tags.join(' ')}'
              .toLowerCase();
      return (query.isEmpty || text.contains(query)) &&
          (_category == null || recipe.category == _category) &&
          (_difficulty == null || recipe.difficulty == _difficulty);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    return PagePadding(
      child: ListView(
        children: [
          const SectionEyebrow('The recipe index'),
          const SizedBox(height: 10),
          Text(
            'Find your next favorite.',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Fifteen dependable, delicious starting points. Filter by the kind of meal you want to make right now.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 26),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search by dish, ingredient, or mood',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterButton(
                label: 'All categories',
                selected: _category == null,
                onPressed: () => setState(() => _category = null),
              ),
              ...RecipeCategory.values.map(
                (category) => _FilterButton(
                  label: category.label,
                  selected: _category == category,
                  onPressed: () => setState(() => _category = category),
                ),
              ),
              _FilterButton(
                label: 'Easy',
                selected: _difficulty == Difficulty.easy,
                onPressed: () => setState(
                  () => _difficulty = _difficulty == Difficulty.easy
                      ? null
                      : Difficulty.easy,
                ),
              ),
              _FilterButton(
                label: 'Medium',
                selected: _difficulty == Difficulty.medium,
                onPressed: () => setState(
                  () => _difficulty = _difficulty == Difficulty.medium
                      ? null
                      : Difficulty.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '${_filtered.length} recipes',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          if (_filtered.isEmpty)
            _EmptyRecipes(onClear: () {
              setState(() {
                _query = '';
                _category = null;
                _difficulty = null;
              });
            })
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth > 900
                    ? 3
                    : constraints.maxWidth > 560
                        ? 2
                        : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: columns == 1 ? 1.05 : .67,
                  ),
                  itemBuilder: (context, index) => RecipeCard(
                    recipe: _filtered[index],
                    favorites: favorites,
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onPressed(),
    );
  }
}

class _EmptyRecipes extends StatelessWidget {
  const _EmptyRecipes({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(
          children: [
            const Icon(Icons.soup_kitchen_outlined, size: 38),
            const SizedBox(height: 14),
            Text(
              'Nothing in the pantry yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            const Text('Try a broader search or clear one of the filters.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onClear,
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }
}