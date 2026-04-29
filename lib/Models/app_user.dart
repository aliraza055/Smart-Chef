import 'package:flutter/foundation.dart';

class AppUser {
  String uid;
  String name;
  String? gmail;
  String imageUrl;
  int totalRecipes;
  int totalFavorites;
  final DateTime createdAt;
  AppUser({
    required this.uid,
    required this.name,
    required this.gmail,
    required this.imageUrl,
    required this.totalFavorites,
    required this.totalRecipes,
    required this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gmail': gmail,
      'imageUrl': imageUrl,
      'totalReceipes': totalRecipes,
      'totalFavorites': totalFavorites,
      'createdAt': createdAt,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      gmail: map['gmail'],
      imageUrl: map['imageUrl'],
      totalFavorites: map['totalFavorites'],
      totalRecipes: map['totalReceipes'],
      createdAt: map['createdAt'],
    );
  }
}
