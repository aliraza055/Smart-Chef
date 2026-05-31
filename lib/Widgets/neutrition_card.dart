import 'package:flutter/material.dart';

class NutrientCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const NutrientCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ── lib/widgets/health_score_ring.dart ──────────────────────────
class HealthScoreRing extends StatelessWidget {
  final int score;
  const HealthScoreRing({super.key, required this.score});

  Color get _color => score >= 75
      ? const Color(0xFF7ecba1)
      : score >= 50
      ? const Color(0xFFFFC107)
      : const Color(0xFFFF6B6B);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 60,
    height: 60,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: score / 100,
          strokeWidth: 5,
          backgroundColor: Colors.white12,
          valueColor: AlwaysStoppedAnimation(_color),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: TextStyle(
                color: _color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'score',
              style: const TextStyle(color: Colors.white38, fontSize: 8),
            ),
          ],
        ),
      ],
    ),
  );
}
