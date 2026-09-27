import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/recipes.dart';
import 'models/recipe.dart';
import 'router/app_router.dart';
import 'services/favorites_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

class CookMateApp extends StatefulWidget {
  const CookMateApp({required this.favorites, super.key});

  final FavoritesController favorites;

  @override
  State<CookMateApp> createState() => _CookMateAppState();
}

class _CookMateAppState extends State<CookMateApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.favorites);
    widget.favorites.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.favorites.removeListener(_refresh);
    _router.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return FavoritesScope(
      notifier: widget.favorites,
      child: MaterialApp.router(
        title: 'CookMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}

Recipe? recipeForId(String id) {
  for (final recipe in recipes) {
    if (recipe.id == id) return recipe;
  }
  return null;
}