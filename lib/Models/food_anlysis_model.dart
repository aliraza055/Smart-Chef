class FoodAnalysis {
  final String foodName;
  final String cuisineType;
  final String servingSize;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final double vitaminC;
  final double iron;
  final int healthScore;
  final List<String> allergens;
  final List<String> dietTags;
  final List<String> healthTips;

  const FoodAnalysis({
    required this.foodName,
    required this.cuisineType,
    required this.servingSize,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.vitaminC,
    required this.iron,
    required this.healthScore,
    required this.allergens,
    required this.dietTags,
    required this.healthTips,
  });

  factory FoodAnalysis.fromJson(Map<String, dynamic> j) => FoodAnalysis(
    foodName: j['foodName'] as String,
    cuisineType: j['cuisineType'] as String,
    servingSize: j['servingSize'] as String,
    calories: (j['calories'] as num).toInt(),
    protein: (j['protein'] as num).toDouble(),
    carbs: (j['carbs'] as num).toDouble(),
    fat: (j['fat'] as num).toDouble(),
    fiber: (j['fiber'] as num).toDouble(),
    sugar: (j['sugar'] as num).toDouble(),
    sodium: (j['sodium'] as num).toDouble(),
    vitaminC: (j['vitaminC'] as num).toDouble(),
    iron: (j['iron'] as num).toDouble(),
    healthScore: (j['healthScore'] as num).toInt(),
    allergens: List<String>.from(j['allergens'] ?? []),
    dietTags: List<String>.from(j['dietTags'] ?? []),
    healthTips: List<String>.from(j['healthTips'] ?? []),
  );
}
