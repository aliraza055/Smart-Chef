import 'package:flutter/material.dart';

class ReceipeModel {
  String name;
  String description;
  String image;
  String category;
  List<String> ingridents;
  String userName;
  String userphoto;
  String difficulity;
  double time;
  double rated;
  int likes;
  ReceipeModel({
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.userName,
    required this.ingridents,
    required this.difficulity,
    required this.userphoto,
    required this.likes,
    required this.rated,
    required this.time,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'image': image,
      'userName': userName,
      'userPhoto': userphoto,
      'ingridents': ingridents,
      'time': time,
      'rating': rated,
      'like': likes,
    };
  }
}
