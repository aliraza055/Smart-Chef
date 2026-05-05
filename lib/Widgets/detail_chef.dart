import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Widgets/safe_image.dart';

class ChefCard extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String level;

  const ChefCard({
    required this.name,
    required this.photoUrl,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: SafeNetworkImage(
                url: photoUrl,
                fit: BoxFit.cover,
                placeholder: Container(
                  color: const Color(0xFFEEEEEE),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppTheme.textLight,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name + level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recipe by',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
