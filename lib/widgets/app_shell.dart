import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/favorites_controller.dart';
import '../theme/app_theme.dart';

class FavoritesScope extends InheritedNotifier<FavoritesController> {
  const FavoritesScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static FavoritesController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<FavoritesScope>();
    assert(scope != null, 'FavoritesScope is missing above this widget.');
    return scope!.notifier!;
  }
}

class AppShell extends StatelessWidget {
  const AppShell({required this.favorites, required this.child, super.key});

  final FavoritesController favorites;
  final Widget child;

  int _selectedIndex(String location) {
    if (location.startsWith('/recipes')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/favorites')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selected = _selectedIndex(location);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.go('/'),
          child: const Text('CookMate.'),
        ),
        actions: [
          IconButton(
            tooltip: 'Search recipes',
            onPressed: () => context.go('/search'),
            icon: const Icon(Icons.search_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.tonal(
              onPressed: () => context.go('/submit'),
              child: const Text('Share a recipe'),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) => context.go(
          switch (index) {
            0 => '/',
            1 => '/recipes',
            2 => '/search',
            _ => '/favorites',
          },
        ),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Discover',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Recipes',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: favorites.count > 0,
              label: Text('${favorites.count}'),
              child: const Icon(Icons.favorite_border_rounded),
            ),
            selectedIcon: const Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}

class PagePadding extends StatelessWidget {
  const PagePadding({required this.child, this.maxWidth = 1180, super.key});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth < 600 ? 20.0 : 42.0;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 28,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.apricot,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
    );
  }
}