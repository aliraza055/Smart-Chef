import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_chef/core/routes/page_router.dart';
import 'package:smart_chef/features/onboarding/models/onboarding_item.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  static const String _onboardingCompletedKey = 'onboarding_completed';

  final List<OnboardingItem> items = const [
    OnboardingItem(
      title: 'Turn Your Ingredients Into Delicious Meals',
      subtitle:
          'Discover incredible recipes tailored to what you already have in your kitchen. Save money and cut food waste.',
      badgeText: 'Smart Cooking Assistant',
      icon: Icons.restaurant_menu_rounded,
      imagePath: 'images/receipe1.jpg',
    ),
    OnboardingItem(
      title: 'Your Personal AI Chef',
      subtitle:
          'Generate instant custom recipes, analyze meals, and receive intelligent nutrition recommendations.',
      badgeText: 'AI Powered Intelligence',
      icon: Icons.auto_awesome_rounded,
      imagePath: 'images/chef.jpg',
    ),
    OnboardingItem(
      title: 'Cook Smarter. Eat Better.',
      subtitle:
          'Elevate your daily culinary experience with instant step-by-step guides and smart recipe discovery.',
      badgeText: 'Ready To Cook?',
      icon: Icons.soup_kitchen_rounded,
      imagePath: 'images/smart_chef_logo.jpg',
    ),
  ];

  bool get isLastPage => currentPage.value == items.length - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage(BuildContext context) {
    if (isLastPage) {
      completeOnboardingAndNavigate(context);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void skip(BuildContext context) {
    completeOnboardingAndNavigate(context);
  }

  Future<void> completeOnboardingAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);

    if (context.mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, PageRouter.singIn);
      }
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
