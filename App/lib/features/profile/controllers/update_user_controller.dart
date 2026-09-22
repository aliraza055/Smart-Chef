import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/core/routes/page_router.dart';
import 'package:smart_chef/core/services/image_picker_service.dart';
import 'package:smart_chef/core/services/image_upload_service.dart';

class UpdateUserController extends GetxController {
  late final TextEditingController nameController;
  late final TextEditingController emailController;

  final Rx<File?> image = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  User? get _user => FirebaseAuth.instance.currentUser;
  String? get currentPhotoUrl => _user?.photoURL;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: _user?.displayName ?? '');
    emailController = TextEditingController(text: _user?.email ?? '');
  }

  Future<void> pickImage() async {
    final picked = await ImagePickerService().pickFromGallery();
    if (picked != null) image.value = picked;
  }

  Future<void> saveChanges() async {
    final user = _user;
    if (user == null) return;

    isLoading.value = true;

    try {
      String? imageUrl;

      if (image.value != null) {
        imageUrl = await ImageUploadService().uploadImage(image.value!);
      }

      await user.updateDisplayName(nameController.text.trim());
      if (imageUrl != null) await user.updatePhotoURL(imageUrl);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
            'name': nameController.text.trim(),
            'imageUrl': imageUrl ?? user.photoURL ?? '',
          });

      // NOTE: AuthController (dusri file mein banaya tha) already
      // FirebaseAuth.instance.userChanges() sun raha hai. Jaise hi
      // updateDisplayName/updatePhotoURL upar call hote hain,
      // AuthController ka Rx<User?> khud refresh ho jayega — UserInfo
      // page (aur jahan bhi AuthController use ho raha hai) apne aap
      // naya data dikhayega. Yahan se manually kuch refresh/notify
      // karne ki zaroorat nahi — yehi GetX ke reactive pattern ka
      // fayda hai.

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );

      Get.offNamed(PageRouter.bottomNav);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}

