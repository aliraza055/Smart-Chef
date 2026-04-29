import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Pages/bottom_navigation.dart';
import 'package:smart_chef/Pages/home_page.dart';
import 'package:smart_chef/Pages/welcome_page.dart';
import 'package:smart_chef/Routers/page_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //  home: BottomNavigation(),
      initialRoute: PageRouter.initial,
      onGenerateRoute: PageRouter.generateRoute,
    );
  }
}
