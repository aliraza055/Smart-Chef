import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef/Routers/page_router.dart';

class SettingsController extends GetxController {
  final RxBool darkMode = false.obs;
  final RxBool notifications = true.obs;

  static const String _darkModeKey = 'dark_mode_enabled';

  @override
  void onInit() {
    super.onInit();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_darkModeKey) ?? false;
    darkMode.value = saved;
    Get.changeThemeMode(saved ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notifications.value = value;
  }

  Future<void> toggleDarkMode(bool value) async {
    darkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (Get.context != null && Get.context!.mounted) {
      Get.offAllNamed(PageRouter.singIn);
    }
  }
}

