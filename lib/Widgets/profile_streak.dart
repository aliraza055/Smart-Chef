import 'package:flutter/material.dart';

class LevelStreakRow extends StatelessWidget {
  final String level;
  final int streakDays;

  const LevelStreakRow({
    super.key,
    required this.level,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Level card ───────────────────────────────
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
                Row(
                  children: [
                    const Icon(
                      Icons.restaurant_menu_rounded,
                      color: Color(0xFF2E7D32),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Text(
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
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _levelProgress(level),
                    minHeight: 5,
                    backgroundColor: const Color(0xFFC8E6C9),
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        // ── Streak card ──────────────────────────────
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFF8B6914),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Text(
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
                const SizedBox(height: 8),
                Text(
                  '$streakDays Days',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8B6914),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 5), // height match karne ke liye
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _levelProgress(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 0.25;
      case 'intermediate':
        return 0.5;
      case 'pro':
        return 0.75;
      case 'master':
        return 1.0;
      default:
        return 0.1;
    }
  }
}

