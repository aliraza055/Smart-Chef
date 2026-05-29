class AiRecipeResult {
  final String name;
  final String description;
  final String category;
  final String difficulty;
  final double time;
  final List<String> ingredients;
  final List<String> steps;

  AiRecipeResult({
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.time,
    required this.ingredients,
    required this.steps,
  });

  factory AiRecipeResult.fromJson(Map<String, dynamic> json) {
    return AiRecipeResult(
      name: json['name'] ?? 'AI Recipe',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Dinner',
      difficulty: json['difficulty'] ?? 'medium',
      time: (json['time'] ?? 30).toDouble(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
    );
  }
}
