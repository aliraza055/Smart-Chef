import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/settings_controller.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Utils/app_responsive.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
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
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, PageRouter.bottomNav),
                    child: Container(
                      width: AppResponsive.width(context, 40),
                      height: AppResponsive.height(context, 40),
                      decoration: BoxDecoration(
                        color: AppTheme.getSurface(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.getCardShadow(context),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.width(context, 14)),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.getTextDark(context),
                      letterSpacing: -0.3,
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
              child: _Section(
                title: 'Account',
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageRouter.updateProfile);
                    },
                    child: _Tile(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () => Navigator.pushNamed(
                        context,
                        PageRouter.updateProfile,
                      ),
                    ),
                  ),
                  const _TileDivider(),
                  _Tile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _Section(
                title: 'Preferences',
                children: [
                  _Tile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    subtitle: 'Manage notification settings',
                    trailing: Obx(
                      () => Switch(
                        value: controller.notifications.value,
                        onChanged: controller.toggleNotifications,
                        activeThumbColor: AppTheme.primary,
                      ),
                    ),
                  ),
                  const _TileDivider(),
                  _Tile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    subtitle: 'Switch app appearance',
                    trailing: Obx(
                      () => Switch(
                        value: controller.darkMode.value,
                        activeThumbColor: AppTheme.primary,
                        onChanged: controller.toggleDarkMode,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _Section(
                title: 'Support',
                children: [
                  _Tile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const _TileDivider(),
                  _Tile(
                    icon: Icons.info_outline_rounded,
                    label: 'About App',
                    subtitle: 'Smart Chef v1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: _Section(
                children: [
                  _Tile(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    isDestructive: true,
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      PageRouter.singIn,
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

class _Section extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _Section({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.getTextMedium(context),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppTheme.getSurface(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.getCardShadow(context),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;

  const _Tile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.primary : AppTheme.getTextDark(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.primary.withOpacity(0.08)
                    : (Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF2F2F2)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getTextMedium(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDestructive
                      ? AppTheme.primary
                      : AppTheme.getTextLight(context),
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
  Widget build(BuildContext context) => Divider(
    height: 1,
    indent: 72,
    endIndent: 18,
    color: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF0F0F0),
  );
}

