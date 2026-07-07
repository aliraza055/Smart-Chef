import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef/Models/food_anlysis_model.dart';
import 'package:smart_chef/Services/food_analyzer_services.dart';
import 'package:smart_chef/Services/open_food_services.dart';

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

  // Gemini teen retries ke baad bhi fail ho jaye to ye true ho jata
  // hai — View tab manual-search box dikhata hai.
  final RxBool geminiFailed = false.obs;
  final RxBool isSearchingManually = false.obs;
  final TextEditingController manualSearchController = TextEditingController();

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
      geminiFailed.value = false;
    }
  }

  void reset() {
    selectedImage.value = null;
    analysis.value = null;
    geminiFailed.value = false;
    manualSearchController.clear();
  }

  Future<void> analyzeImage() async {
    if (selectedImage.value == null) return;

    isAnalyzing.value = true;
    geminiFailed.value = false;
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
      // Retries khatam ho chuke — user ko manual search ka option
      // do, taake app "stuck" na lage.
      geminiFailed.value = true;
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

  Future<void> searchManually() async {
    final query = manualSearchController.text.trim();
    if (query.isEmpty) return;

    isSearchingManually.value = true;
    try {
      final result = await OpenFoodFactsService.searchByName(query);
      analysis.value = result;
      geminiFailed.value = false;
    } catch (e) {
      Get.snackbar(
        'Search failed',
        e.toString(),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSearchingManually.value = false;
    }
  }

  @override
  void onClose() {
    pulseController.dispose();
    manualSearchController.dispose();
    super.onClose();
  }
}
