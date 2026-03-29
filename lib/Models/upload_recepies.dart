import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_chef/Models/receipe_model.dart';
import 'package:smart_chef/Services/Receipe_services.dart';
import 'package:smart_chef/Services/image_upload.dart';

class UploadRecepie {
  final ImageUploadService _imageUpload = ImageUploadService();
  Future<void> uploadReceipes({
    required String name,
    required String des,
    required String category,
    required User user,
    required String difficulity,
    required String ingridents,
    required File image,
  }) async {
    try {
      final imgUrl = await _imageUpload.uploadImage(image);
      ReceipeServices().addReceipe(
        ReceipeModel(
          name: name,
          description: des,
          category: category,
          image: imgUrl!,
          userName: user.displayName ?? '',
          ingridents: ingridents,
          difficulity: difficulity,
          userphoto: user.displayName ?? '',
          likes: 0,
          rated: 0,
          time: 20,
          isFav: false,
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
