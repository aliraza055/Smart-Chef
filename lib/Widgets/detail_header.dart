import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_theme.dart';

class DetailHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String category;
  final String time;
  final double rating;
  final int reviews;
  final String calories;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onProfile;

  const DetailHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.time,
    required this.rating,
    required this.reviews,
    required this.calories,
    required this.onBack,
    required this.onSearch,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      width: double.infinity,
      child: Stack(
        children: [
          // ── Full image ──────────────────────────────
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 380,
            width: double.infinity,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              height: 380,
              color: const Color(0xFFE0E0E0),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Colors.white54,
              ),
            ),
          ),

          // ── Gradient overlay (bottom) ───────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.75),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // ── Top bar: back + title + icons ──────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  const Text(
                    'Smart Chef',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      _CircleIconBtn(
                        icon: Icons.search_rounded,
                        onTap: onSearch,
                      ),
                      const SizedBox(width: 8),
                      _CircleIconBtn(
                        icon: Icons.person_outline_rounded,
                        onTap: onProfile,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags row
                Row(
                  children: [
                    _OverlayTag(
                      label: category.toUpperCase(),
                      color: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 8),
                    _OverlayTag(
                      label: '$time MINS',
                      color: Colors.black45,
                      icon: Icons.access_time_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppTheme.starColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews reviews)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      calories,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 18, color: AppTheme.textDark),
      ),
    );
  }
}

class _OverlayTag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _OverlayTag({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
