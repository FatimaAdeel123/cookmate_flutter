import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../widgets/app_shell.dart';
import '../widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesScope.of(context);
    final results = recipes.where((recipe) {
      final content =
          '${recipe.title} ${recipe.description} ${recipe.ingredients.join(' ')} ${recipe.tags.join(' ')}'
              .toLowerCase();
      return _query.trim().isNotEmpty && content.contains(_query.toLowerCase());
    }).toList();
    return PagePadding(
      child: ListView(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  const SectionEyebrow('Ingredient intelligence'),
                  const SizedBox(height: 10),
                  Text(
                    'What’s in your kitchen?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    autofocus: true,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () => setState(() => _query = ''),
                              icon: const Icon(Icons.close_rounded),
                            ),
                      hintText: 'Try “tomato”, “quick”, or “something cozy”',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_query.isEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Suggestion(
                  title: 'Something fresh',
                  query: 'lemon',
                  onTap: (query) => setState(() => _query = query),
                ),
                _Suggestion(
                  title: 'A 30-minute dinner',
                  query: '30-minute',
                  onTap: (query) => setState(() => _query = query),
                ),
                _Suggestion(
                  title: 'A little comfort',
                  query: 'comfort',
                  onTap: (query) => setState(() => _query = query),
                ),
              ],
            )
          else if (results.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 70),
                child: Text(
                  'No matches yet. Try a single ingredient or a feeling like “cozy”.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${results.length} ideas for “$_query”',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
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
                      itemCount: results.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: columns == 1 ? 1.05 : .67,
                      ),
                      itemBuilder: (context, index) => RecipeCard(
                        recipe: results[index],
                        favorites: favorites,
                      ),
                    );
                  },
                ),
              ],
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Suggestion extends StatelessWidget {
  const _Suggestion({
    required this.title,
    required this.query,
    required this.onTap,
  });

  final String title;
  final String query;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => onTap(query),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .72),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDCE4DE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TRY SEARCHING',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}