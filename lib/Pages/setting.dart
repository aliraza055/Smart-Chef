import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Routers/page_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, PageRouter.bottomNav),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppTheme.cardShadow, blurRadius: 8),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Account Section ──────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
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

          // ── Preferences Section ──────────────────────
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
                    trailing: Switch(
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      activeThumbColor: AppTheme.primary,
                    ),
                  ),
                  const _TileDivider(),
                  _Tile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    subtitle: 'Switch app appearance',
                    trailing: Switch(
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                      activeThumbColor: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Support Section ──────────────────────────
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

          // ── Logout ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: _Section(
                children: [
                  _Tile(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    isDestructive: true,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          PageRouter.singIn,
                        );
                      }
                    },
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

// ── Section card ────────────────────────────────────────
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
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMedium,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
        ],
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
          child: Column(children: children),
        ),
      ],
    );
  }
}

// ── Tile ────────────────────────────────────────────────
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
    final color = isDestructive ? AppTheme.primary : AppTheme.textDark;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.primary.withOpacity(0.08)
                    : const Color(0xFFF2F2F2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 19, color: color),
            ),
            const SizedBox(width: 14),

            // Label + subtitle
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing
            trailing ??
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

// ── Divider ─────────────────────────────────────────────
class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) => const Divider(
    height: 1,
    indent: 72,
    endIndent: 18,
    color: Color(0xFFF0F0F0),
  );
}
