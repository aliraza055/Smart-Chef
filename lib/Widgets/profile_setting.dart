import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_theme.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onSavedCollections;
  final VoidCallback onCookingReminders;
  final VoidCallback onAccountSettings;
  final VoidCallback onSignOut;

  const SettingsMenu({
    super.key,
    required this.onEditProfile,
    required this.onSavedCollections,
    required this.onCookingReminders,
    required this.onAccountSettings,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings & Preferences',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.getTextDark(context),
          ),
        ),
        const SizedBox(height: 14),
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
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.bookmark_outline_rounded,
                label: 'Saved Collections',
                onTap: onSavedCollections,
              ),
              _Separator(),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: 'Cooking Reminders',
                onTap: onCookingReminders,
              ),
              _Separator(),
              _SettingsTile(
                icon: Icons.settings_outlined,
                label: 'Account Settings',
                onTap: onAccountSettings,
              ),
              _Separator(),
              _SettingsTile(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                onTap: onSignOut,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
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
    final color = isDestructive ? AppTheme.primary : AppTheme.getTextDark(context);

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
                    : (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFF2F2F2)),
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
              color: isDestructive ? AppTheme.primary : AppTheme.getTextLight(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 70,
      endIndent: 18,
      color: AppTheme.getDivider(context),
    );
  }
}

