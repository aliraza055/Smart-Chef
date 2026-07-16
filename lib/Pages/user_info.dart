import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/auth_controller.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Utils/app_responsive.dart';
import 'package:smart_chef/Widgets/safe_image.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(
      AuthController(),
      permanent: true,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 56),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Smart Chef',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: AppResponsive.width(context, 42),
                    height: AppResponsive.height(context, 42),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primary, width: 2),
                    ),
                    child: ClipOval(
                      child: Obx(
                        () => SafeNetworkImage(
                          url: controller.photoUrl,
                          placeholder: const Icon(
                            Icons.person_rounded,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 28),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: AppResponsive.width(context, 100),
                        height: AppResponsive.height(context, 100),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primary, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Obx(
                            () => SafeNetworkImage(
                              url: controller.photoUrl,
                              fit: BoxFit.cover,
                              placeholder: Container(
                                color: const Color(0xFFEEEEEE),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(PageRouter.updateProfile),
                          child: Container(
                            width: AppResponsive.width(context, 28),
                            height: AppResponsive.height(context, 28),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Text(
                      controller.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => Text(
                      controller.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // NOTE: ye stats abhi bhi hardcoded/static hain
                  // (48, 1.2k, 342, "Master", "12 Days"). Ye GetX se
                  // related issue nahi hai — jab RecipeController /
                  // UserStatsController banega (real Firestore data
                  // ke liye) tab inko wire karenge. Abhi ke liye
                  // as-is chhoड़ diya, sirf navigation/state pattern
                  // migrate kiya hai.
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatItem(value: '48', label: 'RECIPES'),
                      _Divider(),
                      _StatItem(value: '1.2k', label: 'FOLLOWERS'),
                      _Divider(),
                      _StatItem(value: '342', label: 'FOLLOWING'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 24),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF7ED),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu_rounded,
                                color: Color(0xFF2E7D32),
                                size: 15,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'LEVEL',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2E7D32),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Master',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 1.0,
                              minHeight: 5,
                              backgroundColor: Color(0xFFC8E6C9),
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0E8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: Color(0xFF8B6914),
                                size: 15,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'STREAK',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8B6914),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '12 Days',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF8B6914),
                            ),
                          ),
                          SizedBox(height: 13),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 28),
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings & Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.cardShadow,
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.bookmark_outline_rounded,
                          label: 'Saved Collections',
                          onTap: () => Get.toNamed(PageRouter.favoritePage),
                        ),
                        const _TileDivider(),
                        _SettingsTile(
                          icon: Icons.notifications_outlined,
                          label: 'Cooking Reminders',
                          onTap: () {},
                        ),
                        const _TileDivider(),
                        _SettingsTile(
                          icon: Icons.settings_outlined,
                          label: 'Account Settings',
                          onTap: () => Get.toNamed(PageRouter.updateProfile),
                        ),
                        const _TileDivider(),
                        _SettingsTile(
                          icon: Icons.logout_rounded,
                          label: 'Sign Out',
                          isDestructive: true,
                          onTap: () async {
                            await controller.signOut();
                            Get.offAllNamed(PageRouter.singUp);
                          },
                        ),
                      ],
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
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMedium,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1.5, height: 32, color: const Color(0xFFE0E0E0));
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.primary : AppTheme.textDark;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.primary.withOpacity(0.08)
                    : const Color(0xFFF2F2F2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive ? AppTheme.primary : AppTheme.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();
  @override
  Widget build(BuildContext context) => const Divider(
    height: 1,
    indent: 70,
    endIndent: 18,
    color: Color(0xFFF0F0F0),
  );
}

