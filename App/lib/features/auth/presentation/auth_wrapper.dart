import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef/features/shell/presentation/bottom_navigation.dart';
import 'package:smart_chef/features/auth/presentation/sign_up.dart';
import 'package:smart_chef/features/onboarding/presentation/onboarding_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return BottomNavigation();
        }

        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, prefsSnapshot) {
            if (!prefsSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final completed =
                prefsSnapshot.data?.getBool('onboarding_completed') ?? false;
            if (!completed) {
              return OnboardingPage();
            }
            return SignUp();
          },
        );
      },
    );
  }
}
