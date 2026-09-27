import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/recipes.dart';
import '../widgets/app_shell.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    final saved =
        recipes.where((recipe) => favorites.contains(recipe.id)).toList();
    return PagePadding(
      child: ListView(
        children: [
          const SectionEyebrow('Your personal shelf'),
          const SizedBox(height: 10),
          Text(
            'Saved for later.',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 10),
          Text(
            saved.isEmpty
                ? 'A place for the recipes you cannot stop thinking about.'
                : '${saved.length} recipes waiting for their moment.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          if (saved.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 70),
                child: Column(
                  children: [
                    const Icon(Icons.favorite_border_rounded, size: 42),
                    const SizedBox(height: 14),
                    Text(
                      'Your shelf is waiting',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap the heart on a recipe that makes you want to get in the kitchen.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () => context.go('/recipes'),
                      child: const Text('Explore recipes'),
                    ),
                  ],
                ),
              ),
            )
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
                  itemCount: saved.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: columns == 1 ? 1.05 : .67,
                  ),
                  itemBuilder: (context, index) => RecipeCard(
                    recipe: saved[index],
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