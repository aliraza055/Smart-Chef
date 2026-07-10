import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Routers/page_router.dart';

class SettingsController extends GetxController {
  final RxBool darkMode = false.obs;
  final RxBool notifications = true.obs;

  void toggleNotifications(bool value) {
    notifications.value = value;
  }

  void toggleDarkMode(bool value) {
    darkMode.value = value;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (Get.context != null && Get.context!.mounted) {
      Get.offAllNamed(PageRouter.singIn);
    }
  }
}
