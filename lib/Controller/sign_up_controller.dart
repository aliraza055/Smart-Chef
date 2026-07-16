import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Models/auth_model.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final context = Get.context;

    if (context == null) {
      isLoading.value = false;
      return;
    }

    await AuthModel().signup(
      context,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );

    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

