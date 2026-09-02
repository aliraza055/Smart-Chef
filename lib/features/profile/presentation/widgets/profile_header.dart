import 'package:flutter/material.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/core/widgets/safe_image.dart';

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String bio;
  final int recipes;
  final int followers;
  final int following;
  final VoidCallback onEditTap;

  const ProfileHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.bio,
    required this.recipes,
    required this.followers,
    required this.following,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Avatar with edit badge ──────────────────
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
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
                child: SafeNetworkImage(
                  url: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: Container(
                    color: AppTheme.getDivider(context),
                    child: Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: AppTheme.getTextLight(context),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.getSurface(context), width: 2),
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

        // ── Name ────────────────────────────────────
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.getTextDark(context),
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 6),

        // ── Bio ─────────────────────────────────────
        Text(
          bio.isNotEmpty ? bio : 'Home Cook & Food Enthusiast',
          style: TextStyle(fontSize: 13, color: AppTheme.getTextMedium(context)),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // ── Stats row ───────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatItem(value: _formatNum(recipes), label: 'RECIPES'),
            _Divider(),
            _StatItem(value: _formatNum(followers), label: 'FOLLOWERS'),
            _Divider(),
            _StatItem(value: _formatNum(following), label: 'FOLLOWING'),
          ],
        ),
      ],
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
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
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextMedium(context),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 32, width: 1.5, color: AppTheme.getDivider(context));
  }
}

