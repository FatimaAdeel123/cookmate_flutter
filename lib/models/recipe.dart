enum RecipeCategory { breakfast, lunch, dinner }

enum Difficulty { easy, medium, advanced }

extension RecipeCategoryLabel on RecipeCategory {
  String get label => switch (this) {
        RecipeCategory.breakfast => 'Breakfast',
        RecipeCategory.lunch => 'Lunch',
        RecipeCategory.dinner => 'Dinner',
      };
}

extension DifficultyLabel on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.advanced => 'Advanced',
      };
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.difficulty,
    required this.servings,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.tags,
  });

  final String id;
  final String title;
  final RecipeCategory category;
  final String description;
  final int prepMinutes;
  final int cookMinutes;
  final Difficulty difficulty;
  final int servings;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> tags;

  int get totalMinutes => prepMinutes + cookMinutes;
}