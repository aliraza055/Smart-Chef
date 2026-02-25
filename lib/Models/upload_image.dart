import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UploadImage {
  File? selectedImage;
  Future<void> selectImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    } else {
      selectedImage == File(image.path);
    }
  }
}
