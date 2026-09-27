import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/recipes.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    final featured = recipes[8];
    final quickRecipes = recipes.take(4).toList();
    return ListView(
      children: [
        _HeroSection(featured: featured),
        PagePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const SectionEyebrow('Start somewhere good'),
              const SizedBox(height: 8),
              Text(
                'What are you in the mood for?',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 850 ? 4 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quickRecipes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: columns == 4 ? .72 : .67,
                    ),
                    itemBuilder: (context, index) => RecipeCard(
                      recipe: quickRecipes[index],
                      favorites: favorites,
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              const _KitchenNote(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.featured});

  final Recipe featured;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.evergreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 760;
              return Flex(
                direction: stacked ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (stacked)
                    const _HeroCopy(stacked: true)
                  else
                    const Expanded(flex: 9, child: const _HeroCopy(stacked: false)),
                  SizedBox(
                    width: stacked ? double.infinity : 26,
                    height: stacked ? 28 : 0,
                  ),
                  if (stacked)
                    _FeaturedRecipe(recipe: featured)
                  else
                    Expanded(
                      flex: 11,
                      child: _FeaturedRecipe(recipe: featured),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.stacked});

  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: stacked ? 18 : 48,
        horizontal: stacked ? 0 : 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionEyebrow('The good part starts here'),
          const SizedBox(height: 18),
          Text(
            'Cook with a little more feeling.',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: stacked ? 56 : 72,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recipes with a point of view, for the nights when you want dinner to feel like a decision you are proud of.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: .78),
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.apricot,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => context.go('/recipes'),
                child: const Text('Browse all recipes'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: .35)),
                ),
                onPressed: () => context.go('/search'),
                child: const Text('I have an ingredient'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturedRecipe extends StatelessWidget {
  const _FeaturedRecipe({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push('/recipe/${recipe.id}'),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'recipe-image-${recipe.id}',
              child: RecipeImage(recipe: recipe, borderRadius: 28),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xD9000000)],
                  stops: [.45, 1],
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TONIGHT’S INVITATION',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: .8),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Open recipe  →',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KitchenNote extends StatelessWidget {
  const _KitchenNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(26),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 650;
          return Flex(
            direction: stacked ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stacked)
                const _KitchenNoteCopy()
              else
                const Expanded(flex: 8, child: _KitchenNoteCopy()),
              SizedBox(
                width: stacked ? 0 : 20,
                height: stacked ? 20 : 0,
              ),
              if (stacked)
                const _KitchenNoteImages()
              else
                const Expanded(flex: 5, child: _KitchenNoteImages()),
            ],
          );
        },
      ),
    );
  }
}

class _KitchenNoteCopy extends StatelessWidget {
  const _KitchenNoteCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionEyebrow('A note from the kitchen'),
        const SizedBox(height: 10),
        Text(
          'Good food is a form of attention.',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 14),
        Text(
          'CookMate is for the recipes that make you pause at the market, invite someone over, or take the long way home.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => context.go('/submit'),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('Add your own recipe'),
        ),
      ],
    );
  }
}

class _KitchenNoteImages extends StatelessWidget {
  const _KitchenNoteImages();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RecipeImage(
            recipe: recipes[4],
            height: 220,
            borderRadius: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RecipeImage(
            recipe: recipes[13],
            height: 220,
            borderRadius: 18,
          ),
        ),
      ],
    );
  }
}