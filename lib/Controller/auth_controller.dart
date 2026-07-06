import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Yeh controller poori app mein sirf ek dafa banega aur shared
/// rahega (login/logout ke through). AuthWrapper, sign_in, sign_up,
/// update_user — sab isko reuse karenge jab unko migrate karenge.
///
/// Firebase ka `userChanges()` stream `authStateChanges()` se
/// zyada powerful hai: ye sirf login/logout par nahi, balki jab
/// displayName ya photoURL update ho tab bhi fire hota hai. Isliye
/// jaise hi UpdateUser page profile change karega, ye controller
/// khud-ba-khud naya data uthayega — aur jahan bhi Obx() laga hai
/// wahan UI turant refresh ho jayegi, koi manual reload/Navigator
/// pop-push ki zaroorat nahi.
class AuthController extends GetxController {
  final Rx<User?> firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
  }

  String get name => firebaseUser.value?.displayName ?? 'Chef';
  String get email => firebaseUser.value?.email ?? '';
  String? get photoUrl => firebaseUser.value?.photoURL;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
