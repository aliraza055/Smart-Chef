import 'package:flutter/material.dart';
import 'package:smart_chef/Pages/ai_receipeGenrateor.dart';
import 'package:smart_chef/Pages/analyzer_page.dart';
import 'package:smart_chef/Pages/bottom_navigation.dart';
import 'package:smart_chef/Pages/deital_page.dart';
import 'package:smart_chef/Pages/favorite_item.dart';
import 'package:smart_chef/Pages/home_page.dart';
import 'package:smart_chef/Pages/setting.dart';
import 'package:smart_chef/Pages/sign_in.dart';
import 'package:smart_chef/Pages/sign_up.dart';
import 'package:smart_chef/Pages/update_user.dart';
import 'package:smart_chef/Pages/welcome_page.dart';

class PageRouter {
  static const initial = '/';
  static const singUp = 'singUp';
  static const singIn = 'singIn';
  static const homePage = '/homePage';
  static const detailPage = '/detailPage';
  static const favoritePage = '/favoritePage';
  static const bottomNav = '/bottomNav';
  static const updateProfile = '/update profile';
  static const settingPage = '/settingPage';
  static const receipeAi = '/receipeAi';
  static const foodAnalyser = '/foodAnalyser';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => SmartChefSplashScreen());
      case singUp:
        return MaterialPageRoute(builder: (_) => SignUp());
      case singIn:
        return MaterialPageRoute(builder: (_) => SignIn());
      case homePage:
        return MaterialPageRoute(builder: (_) => Homepage());
      case detailPage:
        final recipe = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => DetailPage(recipe: recipe));
      case favoritePage:
        return MaterialPageRoute(builder: (_) => FavoritePage());
      case foodAnalyser:
        return MaterialPageRoute(builder: (_) => FoodAnalyzerScreen());
      case receipeAi:
        return MaterialPageRoute(builder: (_) => AiRecipeGeneratorPage());
      case bottomNav:
        return MaterialPageRoute(builder: (_) => BottomNavigation());
      case updateProfile:
        return MaterialPageRoute(builder: (_) => UpdateUser());
      case settingPage:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('no page found'))),
        );
    }
  }
}
