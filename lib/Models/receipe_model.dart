class ReceipeModel {
  String name;
  String description;
  String image;
  String category;
  List<String> ingredients; // ✅ String se List<String> — multiple ingredients
  List<String> steps; // ✅ Naya field — preparation steps
  String? userName;
  String? userPhoto;
  String difficulty;
  double time;
  double rated;
  bool isFav;
  int likes;

  ReceipeModel({
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.userName,
    required this.ingredients,
    required this.steps,
    required this.difficulty,
    required this.userPhoto,
    required this.likes,
    required this.rated,
    required this.time,
    required this.isFav,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'userName': userName,
      'userPhoto': userPhoto,
      'ingredients': ingredients, // List<String> — Firestore array ban jayega
      'steps': steps, // List<String> — Firestore array ban jayega
      'time': time,
      'rating': rated,
      'likes': likes,
      'isFav': isFav,
      'difficulty': difficulty,
    };
  }

  // Firestore se data padhne ke liye
  factory ReceipeModel.fromMap(Map<String, dynamic> map) {
    return ReceipeModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      userName: map['userName'],
      userPhoto: map['userPhoto'],
      // Firestore se List safely parse karo
      ingredients: List<String>.from(map['ingredients'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      difficulty: map['difficulty'] ?? 'easy',
      time: (map['time'] ?? 0).toDouble(),
      rated: (map['rating'] ?? 0).toDouble(),
      likes: map['likes'] ?? 0,
      isFav: map['isFav'] ?? false,
    );
  }
}
