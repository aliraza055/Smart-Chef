import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_theme.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  const SocialLoginRow({super.key, this.onGoogleTap, this.onFacebookTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Social buttons
        Row(
          children: [
            Expanded(
              child: _SocialBtn(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
                iconColor: Colors.red,
                onTap: onGoogleTap ?? () {},
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SocialBtn(
                label: 'Facebook',
                icon: Icons.facebook_rounded,
                iconColor: const Color(0xFF1877F2),
                onTap: onFacebookTap ?? () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: Divider(color: AppTheme.primary.withOpacity(0.3))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'OR EMAIL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkTextLight,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppTheme.primary.withOpacity(0.3))),
          ],
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

