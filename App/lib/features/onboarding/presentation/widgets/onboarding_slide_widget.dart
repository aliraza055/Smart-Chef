import 'package:flutter/material.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';
import 'package:smart_chef/features/onboarding/models/onboarding_item.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingSlideWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.horizontalPadding(context, size: 24),
      ),
      child: Column(
        children: [
          // ── Illustration / Image Card Container ─────────────────
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: AppResponsive.height(context, 340),
                ),
                decoration: BoxDecoration(
                  color: AppTheme.getSurface(context),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.12),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Image if provided
                      if (item.imagePath != null)
                        Image.asset(
                          item.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildFallbackIllustration(context),
                        )
                      else
                        _buildFallbackIllustration(context),

                      // Gradient overlay for visual richness
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),

                      // Feature Icon Badge inside image card
                      Positioned(
                        bottom: AppResponsive.height(context, 16),
                        right: AppResponsive.width(context, 16),
                        child: Container(
                          padding: EdgeInsets.all(
                            AppResponsive.width(context, 12),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            item.icon,
                            color: AppTheme.primary,
                            size: AppResponsive.width(context, 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: AppResponsive.height(context, 24)),

          // ── Text & Tag Info Section ──────────────────────────────
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Feature Tag Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.width(context, 14),
                      vertical: AppResponsive.height(context, 7),
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.getPrimarySoft(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: AppResponsive.text(context, 14),
                          color: AppTheme.primary,
                        ),
                        SizedBox(width: AppResponsive.width(context, 6)),
                        Text(
                          item.badgeText,
                          style: TextStyle(
                            fontSize: AppResponsive.text(context, 12),
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppResponsive.height(context, 16)),

                  // Title
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppResponsive.text(context, 26),
                      fontWeight: FontWeight.w800,
                      color: AppTheme.getTextDark(context),
                      height: 1.25,
                      letterSpacing: -0.4,
                    ),
                  ),

                  SizedBox(height: AppResponsive.height(context, 12)),

                  // Subtitle
                  Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppResponsive.text(context, 14),
                      fontWeight: FontWeight.w400,
                      color: AppTheme.getTextMedium(context),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIllustration(BuildContext context) {
    return Container(
      color: AppTheme.getPrimarySoft(context),
      child: Center(
        child: Icon(
          item.icon,
          size: AppResponsive.width(context, 90),
          color: AppTheme.primary.withOpacity(0.8),
        ),
      ),
    );
  }
}
