import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String uid;
  String name;
  String? gmail;
  String imageUrl;
  int totalRecipes;
  int totalFavorites;
  // New fields matching design
  String bio;
  int followers;
  int following;
  String level; // 'Master', 'Pro', 'Beginner'
  int streakDays;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.name,
    required this.gmail,
    required this.imageUrl,
    required this.totalFavorites,
    required this.totalRecipes,
    required this.createdAt,
    this.bio = '',
    this.followers = 0,
    this.following = 0,
    this.level = 'Beginner',
    this.streakDays = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gmail': gmail,
      'imageUrl': imageUrl,
      'totalRecipes': totalRecipes, // ✅ typo fix (was totalReceipes)
      'totalFavorites': totalFavorites,
      'bio': bio,
      'followers': followers,
      'following': following,
      'level': level,
      'streakDays': streakDays,
      'createdAt': createdAt,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      gmail: map['gmail'],
      imageUrl: map['imageUrl'] ?? '',
      totalFavorites: map['totalFavorites'] ?? 0,
      totalRecipes: map['totalRecipes'] ?? 0, // ✅ typo fix
      bio: map['bio'] ?? '',
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      level: map['level'] ?? 'Beginner',
      streakDays: map['streakDays'] ?? 0,
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
