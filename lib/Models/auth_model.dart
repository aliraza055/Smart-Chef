import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  Future<void> signup(String name, String email, String password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
