import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_chef/Models/receipe_model.dart';
import 'package:smart_chef/Services/Receipe_services.dart';
import 'package:smart_chef/Services/image_upload.dart';

class UploadRecepie {
  final ImageUploadService _imageUpload = ImageUploadService();

  Future<void> uploadReceipes({
    required String name,
    required String description,
    required String category,
    required User? user,
    required String difficulty,
    required List<String> ingredients, // ✅ String se List<String>
    required List<String> steps, // ✅ Naya field
    required File image,
    double time = 20,
  }) async {
    try {
      final imgUrl = await _imageUpload.uploadImage(image);

      await ReceipeServices().addReceipe(
        ReceipeModel(
          name: name,
          description: description,
          category: category,
          image: imgUrl!,
          userName: user?.displayName ?? 'Anonymous',
          userPhoto: user?.photoURL ?? '',
          ingredients: ingredients, // ✅ List<String>
          steps: steps, // ✅ List<String>
          difficulty: difficulty,
          likes: 0,
          rated: 0,
          time: time,
          isFav: false,
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
