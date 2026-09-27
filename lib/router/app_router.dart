import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/recipes_screen.dart';
import '../screens/search_screen.dart';
import '../screens/submit_recipe_screen.dart';
import '../services/favorites_controller.dart';
import '../widgets/app_shell.dart';

GoRouter createRouter(FavoritesController favorites) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(favorites: favorites, child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/recipes', builder: (_, __) => const RecipesScreen()),
          GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          GoRoute(
            path: '/favorites',
            builder: (_, __) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/recipe/:id',
            builder: (_, state) =>
                RecipeDetailScreen(recipeId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/submit',
            builder: (_, __) => const SubmitRecipeScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => context.go('/'),
          child: const Text('Return to CookMate'),
        ),
      ),
    ),
  );
}