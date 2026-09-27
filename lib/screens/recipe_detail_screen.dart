import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/recipe_image.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({required this.recipeId, super.key});

  final String recipeId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<int> _checkedIngredients = {};
  late int _servings;

  @override
  void initState() {
    super.initState();
    _servings = recipeForId(widget.recipeId)?.servings ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = recipeForId(widget.recipeId);
    if (recipe == null) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/recipes'),
            child: const Text('Back to recipes'),
          ),
        ),
      );
    }
    final favorites = FavoritesScope.of(context);
    final saved = favorites.contains(recipe.id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: AppTheme.evergreen,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: saved ? 'Remove from favorites' : 'Save to favorites',
                onPressed: () => favorites.toggle(recipe.id),
                icon: Icon(
                  saved
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Text(
                recipe.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black45, blurRadius: 12),
                      ],
                    ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe-image-${recipe.id}',
                    child: RecipeImage(recipe: recipe, borderRadius: 0),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x33000000), Color(0xCC000000)],
                        stops: [.3, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: PagePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.category.label.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.apricot,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 22),
                  _RecipeStats(recipe: recipe, servings: _servings),
                  const SizedBox(height: 18),
                  _ServingsControl(
                    servings: _servings,
                    onChanged: (value) => setState(() => _servings = value),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    'Gather your ingredients',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap each item as it hits the counter.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Column(
                      children: [
                        for (var index = 0;
                            index < recipe.ingredients.length;
                            index++)
                          _IngredientRow(
                            ingredient: recipe.ingredients[index],
                            checked: _checkedIngredients.contains(index),
                            onTap: () => setState(() {
                              if (_checkedIngredients.contains(index)) {
                                _checkedIngredients.remove(index);
                              } else {
                                _checkedIngredients.add(index);
                              }
                            }),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    'Make it yours',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  for (var index = 0; index < recipe.steps.length; index++)
                    _StepRow(number: index + 1, step: recipe.steps[index]),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeStats extends StatelessWidget {
  const _RecipeStats({required this.recipe, required this.servings});

  final Recipe recipe;
  final int servings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(label: 'Total', value: '${recipe.totalMinutes} min'),
        _Stat(label: 'Level', value: recipe.difficulty.label),
        _Stat(label: 'Serves', value: '$servings'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFD6DFD8))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.ink.withValues(alpha: .6),
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 3),
            Text(value, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _ServingsControl extends StatelessWidget {
  const _ServingsControl({
    required this.servings,
    required this.onChanged,
  });

  final int servings;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('Adjust servings', style: Theme.of(context).textTheme.labelLarge),
          const Spacer(),
          IconButton(
            onPressed: () => onChanged(servings > 1 ? servings - 1 : 1),
            icon: const Icon(Icons.remove_rounded),
          ),
          Text('$servings', style: Theme.of(context).textTheme.labelLarge),
          IconButton(
            onPressed: () => onChanged(servings + 1),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.checked,
    required this.onTap,
  });

  final String ingredient;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: checked ? AppTheme.evergreen : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: checked ? AppTheme.evergreen : const Color(0xFFBAC9BE),
                ),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration:
                          checked ? TextDecoration.lineThrough : null,
                      color: checked ? AppTheme.ink.withValues(alpha: .5) : null,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.step});

  final int number;
  final String step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number.toString().padLeft(2, '0'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.apricot,
                ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(step, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}