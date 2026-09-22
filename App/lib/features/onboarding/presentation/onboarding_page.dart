import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';
import 'package:smart_chef/features/onboarding/controllers/onboarding_controller.dart';
import 'package:smart_chef/features/onboarding/presentation/widgets/onboarding_slide_widget.dart';
import 'package:smart_chef/features/onboarding/presentation/widgets/page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar (Logo & Skip) ──────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.horizontalPadding(context, size: 24),
                vertical: AppResponsive.height(context, 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Header
                  Row(
                    children: [
                      Container(
                        width: AppResponsive.width(context, 34),
                        height: AppResponsive.width(context, 34),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'images/smart_chef_logo.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: AppTheme.primary,
                                  child: const Icon(
                                    Icons.restaurant,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppResponsive.width(context, 10)),
                      Text(
                        'SmartChef',
                        style: TextStyle(
                          fontSize: AppResponsive.text(context, 18),
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),

                  // Skip Button
                  Obx(
                    () => AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: controller.isLastPage ? 0.0 : 1.0,
                      child: IgnorePointer(
                        ignoring: controller.isLastPage,
                        child: TextButton(
                          onPressed: () => controller.skip(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.getTextMedium(context),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.width(context, 12),
                              vertical: AppResponsive.height(context, 6),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: AppResponsive.text(context, 14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Main PageView Slider ──────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.items.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(item: controller.items[index]);
                },
              ),
            ),

            // ── Bottom Section (Indicators & Dynamic Action Button) ─
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.horizontalPadding(context, size: 24),
                vertical: AppResponsive.height(context, 20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Obx(
                    () => PageIndicator(
                      count: controller.items.length,
                      currentIndex: controller.currentPage.value,
                    ),
                  ),

                  SizedBox(height: AppResponsive.height(context, 24)),

                  // Main Action Button (Next / Get Started)
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: AppResponsive.height(context, 56),
                      child: ElevatedButton(
                        onPressed: () => controller.nextPage(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: AppTheme.primary.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              ),
                          child: Row(
                            key: ValueKey<bool>(controller.isLastPage),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.isLastPage
                                    ? 'Get Started'
                                    : 'Continue',
                                style: TextStyle(
                                  fontSize: AppResponsive.text(context, 16),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(width: AppResponsive.width(context, 8)),
                              Icon(
                                controller.isLastPage
                                    ? Icons.arrow_forward_rounded
                                    : Icons.chevron_right_rounded,
                                size: AppResponsive.text(context, 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
