import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String recipeId;
  String userId;
  String userName;
  String? userPhoto;
  double rating;
  String comment;
  DateTime createdAt;

  ReviewModel({
    this.id,
    required this.recipeId,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto ?? '',
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      recipeId: map['recipeId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhoto: map['userPhoto'],
      rating: (map['rating'] ?? 0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
