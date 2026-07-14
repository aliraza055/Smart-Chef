import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Utils/app_responsive.dart';

class SmartChefSplashScreen extends StatefulWidget {
  const SmartChefSplashScreen({super.key});

  @override
  State<SmartChefSplashScreen> createState() => _SmartChefSplashScreenState();
}

class _SmartChefSplashScreenState extends State<SmartChefSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 52,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.horizontalPadding(
                      context,
                      size: 32,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: AppResponsive.height(context, 60)),
                      Container(
                        width: AppResponsive.width(context, 110),
                        height: AppResponsive.height(context, 110),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.18),
                              blurRadius: 32,
                              spreadRadius: 4,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppTheme.primary,
                          size: 52,
                        ),
                      ),

                      SizedBox(height: AppResponsive.height(context, 36)),

                      // Title
                      Text(
                        'Smart Chef',
                        style: TextStyle(
                          fontSize: AppResponsive.text(context, 38),
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                          letterSpacing: -0.5,
                        ),
                      ),

                      SizedBox(height: AppResponsive.height(context, 12)),

                      // Subtitle
                      Text(
                        'Your culinary journey starts here.',
                        style: TextStyle(
                          fontSize: AppResponsive.text(context, 16),
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                        ),
                      ),

                      SizedBox(height: AppResponsive.height(context, 40)),
                    ],
                  ),
                ),
              ),

              // Bottom section – kitchen image
              Expanded(flex: 48, child: _KitchenImage()),
            ],
          ),

          // Floating bottom action bar
          Positioned(
            bottom: AppResponsive.height(context, 40),
            left: AppResponsive.horizontalPadding(context, size: 20),
            right: AppResponsive.horizontalPadding(context, size: 20),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, PageRouter.singIn),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.width(context, 28),
                  vertical: AppResponsive.height(context, 18),
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Started',
                      style: TextStyle(
                        color: AppTheme.surface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.storefront_rounded,
                      color: AppTheme.surface,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KitchenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/chef1.png', fit: BoxFit.cover),

          // Gradient overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF5F3F0).withOpacity(0.92),
                  const Color(0xFFF5F3F0).withOpacity(0.55),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
