import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/recipe.dart';
import '../services/favorites_controller.dart';
import '../theme/app_theme.dart';
import 'recipe_image.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    required this.recipe,
    required this.favorites,
    this.featured = false,
    super.key,
  });

  final Recipe recipe;
  final FavoritesController favorites;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final saved = favorites.contains(recipe.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/recipe/${recipe.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe-image-${recipe.id}',
              child: SizedBox(
                height: featured ? 280 : 190,
                width: double.infinity,
                child: RecipeImage(recipe: recipe, borderRadius: 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        recipe.category.label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.apricot,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${recipe.totalMinutes} min',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.description,
                    maxLines: featured ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.ink.withValues(alpha: .68),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Serves ${recipe.servings}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: saved ? 'Remove from favorites' : 'Save recipe',
                        onPressed: () => favorites.toggle(recipe.id),
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          saved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: saved ? AppTheme.apricot : AppTheme.ink,
                        ),
                      ),
                    ],
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