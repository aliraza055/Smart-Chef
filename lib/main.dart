import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/settings_controller.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();

  // Load the initial theme mode from preferences
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode_enabled') ?? false;

  // Pre-initialize SettingsController globally
  Get.put(SettingsController());

  runApp(MyApp(initialThemeMode: isDark ? ThemeMode.dark : ThemeMode.light));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Chef',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,
      home: const AuthWrapper(),
      onGenerateRoute: PageRouter.generateRoute,
    );
  }
}

