import 'package:flutter/material.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(
            horizontal: AppResponsive.width(context, 4),
          ),
          height: AppResponsive.height(context, 8),
          width: isActive
              ? AppResponsive.width(context, 28)
              : AppResponsive.width(context, 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary
                : AppTheme.getDivider(context).withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
