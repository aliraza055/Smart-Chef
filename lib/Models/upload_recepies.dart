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
    final dynamic createdAt,
    double time = 20,
  }) async {
    try {
      final imgUrl = await _imageUpload.uploadImage(image);

      await ReceipeServices().addReceipe(
        ReceipeModel(
          name: name,
          userUId: user?.uid ?? '',
          description: description,
          category: category,
          image: imgUrl!,
          userName: user?.displayName ?? 'Anonymous',
          ingredients: ingredients,
          steps: steps,
          difficulty: difficulty,
          userPhoto: user?.photoURL ?? '',
          likes: 0,
          time: time,
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
