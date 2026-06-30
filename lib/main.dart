import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool _darkMode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Chef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      //  home: BottomNavigation(),
      home: const AuthWrapper(),
      onGenerateRoute: PageRouter.generateRoute,
    );
  }
}
