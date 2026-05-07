import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Pages/bottom_navigation.dart';
import 'package:smart_chef/Pages/sign_in.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // ✅ Firebase auth state — login/logout automatically detect karta hai
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ User logged in hai — direct home
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNavigation();
        }

        // ✅ User logged out hai — sign in page
        return const SignIn();
      },
    );
  }
}
