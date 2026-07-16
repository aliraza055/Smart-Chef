import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Models/toast_error.dart';
import 'package:smart_chef/Models/upload_recepies.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/image_picker.dart';

class AddRecipeController extends GetxController {
  final Rx<File?> image = Rx<File?>(null);
  final RxnString selectedCategory = RxnString();
  final RxBool isLoading = false.obs;
  final List<TextEditingController> ingredientControllers = [];
  final List<TextEditingController> stepControllers = [];
  final TextEditingController titleController = TextEditingController();
  final ImagePickerService _imagePicker = ImagePickerService();
  final User? _user = FirebaseAuth.instance.currentUser;
  final double randomTime = (10 + Random().nextInt(50)).toDouble();

  static const List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Drinks',
  ];

  @override
  void onInit() {
    super.onInit();
    ingredientControllers.add(TextEditingController());
    stepControllers.add(TextEditingController());
  }

  @override
  void onClose() {
    titleController.dispose();
    for (final c in ingredientControllers) {
      c.dispose();
    }
    for (final c in stepControllers) {
      c.dispose();
    }
    super.onClose();
  }

  Future<void> pickImage() async {
    final picked = await _imagePicker.pickFromGallery();
    if (picked != null) image.value = picked;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void addIngredient() {
    ingredientControllers.add(TextEditingController());
    update();
  }

  void deleteIngredient(int index) {
    ingredientControllers[index].dispose();
    ingredientControllers.removeAt(index);
    update();
  }

  void addStep() {
    stepControllers.add(TextEditingController());
    update();
  }

  void deleteStep(int index) {
    stepControllers[index].dispose();
    stepControllers.removeAt(index);
    update();
  }

  void saveDraft() {
    ToastError().showToast(
      message: 'Draft saved!',
      bgColor: Colors.grey.shade700,
    );
  }

  bool _validate() {
    if (image.value == null) {
      ToastError().showToast(
        message: 'Please select recipe image',
        bgColor: Colors.red,
      );
      return false;
    }
    if (titleController.text.trim().isEmpty) {
      ToastError().showToast(
        message: 'Please enter recipe title',
        bgColor: Colors.red,
      );
      return false;
    }
    if (selectedCategory.value == null) {
      ToastError().showToast(
        message: 'Please select category',
        bgColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  Future<void> publish() async {
    if (!_validate()) return;

    isLoading.value = true;

    final ingredients = ingredientControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final steps = stepControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      await UploadRecepie().uploadReceipes(
        name: titleController.text.trim(),
        description: '',
        category: selectedCategory.value!,
        user: _user,
        difficulty: ['easy', 'medium', 'hard'][Random().nextInt(3)],
        ingredients: ingredients,
        steps: steps,
        image: image.value!,
        time: randomTime,
        createdAt: FieldValue.serverTimestamp(),
      );

      Get.offAllNamed(PageRouter.bottomNav);

      ToastError().showToast(
        message: 'Recipe Published Successfully 🎉',
        bgColor: Colors.green,
      );
    } catch (e) {
      ToastError().showToast(
        message: 'Something went wrong: $e',
        bgColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

