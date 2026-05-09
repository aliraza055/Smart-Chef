import 'package:cloud_firestore/cloud_firestore.dart';

class ReceipeModel {
  String? docId;
  String name;
  String description;
  String image;
  String category;
  List<String> ingredients;
  List<String> steps;
  String? userName;
  String? userPhoto;
  String difficulty;
  double time;
  String userUId;
  double avgRating;
  int totalReviews;
  int likes;
  final Timestamp? createdAt;

  ReceipeModel({
    this.docId,
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.userUId,
    required this.userName,
    required this.ingredients,
    required this.steps,
    required this.difficulty,
    required this.userPhoto,
    required this.likes,
    this.avgRating = 0,
    this.totalReviews = 0,
    required this.time,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'userName': userName,
      'userUid': userUId,
      'userPhoto': userPhoto,
      'ingredients': ingredients,
      'steps': steps,
      'time': time,
      'avgRating': avgRating,
      'totalReviews': totalReviews,
      'likes': likes,
      'difficulty': difficulty,
      'createdAt': createdAt,
    };
  }

  factory ReceipeModel.fromMap(Map<String, dynamic> map) {
    return ReceipeModel(
      docId: map['docId'],
      name: map['name'] ?? '',
      userUId: map['userUid'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      userName: map['userName'],
      userPhoto: map['userPhoto'],
      ingredients: List<String>.from(map['ingredients'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      difficulty: map['difficulty'] ?? 'easy',
      time: (map['time'] ?? 0).toDouble(),
      avgRating: (map['avgRating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      likes: map['likes'] ?? 0,
      createdAt: map['createdAt'],
    );
  }
}
