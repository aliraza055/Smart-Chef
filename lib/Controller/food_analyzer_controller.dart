import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef/Models/food_anlysis_model.dart';
import 'package:smart_chef/Services/food_analyzer_services.dart';

/// SingleGetTickerProviderMixin controller ko khud "vsync" bana deta
/// hai — is wajah se pulse animation ke liye ab StatefulWidget +
/// TickerProviderStateMixin ki zaroorat nahi rahi, jaisa original
/// FoodAnalyzerScreen mein tha.
class FoodAnalyzerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<FoodAnalysis?> analysis = Rx<FoodAnalysis?>(null);
  final RxBool isAnalyzing = false.obs;
  final RxString loadingMessage = ''.obs;

  late final AnimationController pulseController;
  late final Animation<double> pulseAnimation;

  static const List<String> _loadingMessages = [
    'Identifying food item...',
    'Calculating nutrients...',
    'Checking allergens...',
    'Generating health tips...',
  ];

  @override
  void onInit() {
    super.onInit();
    pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    pulseAnimation = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (picked != null) {
      selectedImage.value = File(picked.path);
      analysis.value = null;
    }
  }

  void reset() {
    selectedImage.value = null;
    analysis.value = null;
  }

  Future<void> analyzeImage() async {
    if (selectedImage.value == null) return;

    isAnalyzing.value = true;
    loadingMessage.value = _loadingMessages[0];

    for (int i = 1; i < _loadingMessages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      loadingMessage.value = _loadingMessages[i];
    }

    try {
      final result = await AiServiceImage.analyzeFoodImage(
        selectedImage.value!,
      );
      analysis.value = result;
    } on GeminiUnavailableException {
      Get.snackbar(
        'Analysis unavailable',
        'Gemini is not available right now. Please try again shortly.',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Analysis failed',
        e.toString(),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isAnalyzing.value = false;
    }
  }

  @override
  void onClose() {
    pulseController.dispose();
    super.onClose();
  }
}

