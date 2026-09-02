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

  // NAYA FIELD: true hota hai jab data Open Food Facts (fallback)
  // se aaya ho, false jab Gemini se aaya ho (detailed/accurate).
  // UI isko dekh kar "Estimated" badge dikha sakta hai.
  final bool isEstimated;

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
    this.isEstimated = false,
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
    isEstimated: j['isEstimated'] as bool? ?? false,
  );

  // NAYA METHOD: caching ke liye zaroori hai — FoodAnalysis ko wapas
  // JSON string bana kar SharedPreferences mein store karna hai.
  Map<String, dynamic> toJson() => {
    'foodName': foodName,
    'cuisineType': cuisineType,
    'servingSize': servingSize,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
    'sugar': sugar,
    'sodium': sodium,
    'vitaminC': vitaminC,
    'iron': iron,
    'healthScore': healthScore,
    'allergens': allergens,
    'dietTags': dietTags,
    'healthTips': healthTips,
    'isEstimated': isEstimated,
  };
}

