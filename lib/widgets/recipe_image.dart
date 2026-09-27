import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../theme/app_theme.dart';

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    required this.recipe,
    this.height,
    this.width,
    this.borderRadius = 22,
    super.key,
  });

  final Recipe recipe;
  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        recipe.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.apricot, Color(0xFFF0C88A), AppTheme.evergreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(18),
          child: Text(
            recipe.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}