import 'package:flutter/material.dart';
import 'package:smart_chef/features/all_recipes/presentation/all_recipes_page.dart';
import 'package:smart_chef/features/ai_recipe/presentation/ai_recipe_generator_page.dart';
import 'package:smart_chef/features/food_analyzer/presentation/food_analyzer_page.dart';
import 'package:smart_chef/features/settings/presentation/change_password_page.dart';
import 'package:smart_chef/features/shell/presentation/bottom_navigation.dart';
import 'package:smart_chef/features/recipe_detail/presentation/detail_page.dart';
import 'package:smart_chef/features/favorites/presentation/favorite_page.dart';
import 'package:smart_chef/features/home/presentation/home_page.dart';
import 'package:smart_chef/features/settings/presentation/settings_page.dart';
import 'package:smart_chef/features/auth/presentation/sign_in.dart';
import 'package:smart_chef/features/auth/presentation/sign_up.dart';
import 'package:smart_chef/features/profile/presentation/update_user.dart';
import 'package:smart_chef/features/auth/presentation/welcome_page.dart';

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
  static const changePassword = '/changePassword';
  static const allRecipes = '/allRecipes';
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
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case allRecipes:
        return MaterialPageRoute(builder: (_) => const AllRecipesPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('no page found'))),
        );
    }
  }
}
