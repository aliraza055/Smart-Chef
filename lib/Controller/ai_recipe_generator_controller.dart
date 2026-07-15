import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Models/ai_receipe_result_model.dart';
import 'package:smart_chef/Services/ai_services.dart';

class AiRecipeGeneratorController extends GetxController {
  final ingredientController = TextEditingController();
  final RxList<String> ingredients = <String>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<AiRecipeResult> result = Rxn<AiRecipeResult>();
  final RxString errorMessage = ''.obs;

  void addIngredient() {
    final text = ingredientController.text.trim();
    if (text.isEmpty) return;

    if (ingredients.contains(text)) {
      ingredientController.clear();
      return;
    }

    ingredients.add(text);
    ingredientController.clear();
    result.value = null;
    errorMessage.value = '';
  }

  void removeIngredient(String item) {
    ingredients.remove(item);
    result.value = null;
  }

  Future<void> generate() async {
    if (ingredients.isEmpty) {
      errorMessage.value = 'Please enter at least one ingredient.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    result.value = null;

    try {
      final generated = await AiService().generateRecipe(ingredients.toList());
      result.value = generated;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void useThisRecipe() {
    if (result.value == null) return;
    Get.back(result: result.value);
  }

  @override
  void onClose() {
    ingredientController.dispose();
    super.onClose();
  }
}
