import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

class CookingSteps extends StatelessWidget {
  final List<String> steps;
  final String difficulty;
  // Optional: pass a map of stepIndex -> imageUrl if you want images on steps
  final Map<int, String> stepImages;

  const CookingSteps({
    super.key,
    required this.steps,
    this.difficulty = 'Easy',
    this.stepImages = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cooking Steps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppTheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${difficulty.toUpperCase()} LEVEL',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Steps
        ...List.generate(steps.length, (i) {
          final hasImage = stepImages.containsKey(i);
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number circle + vertical line
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: i == 0
                            ? AppTheme.primary
                            : const Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: i == 0 ? Colors.white : AppTheme.textMedium,
                          ),
                        ),
                      ),
                    ),
                    if (i < steps.length - 1)
                      Container(
                        width: 1.5,
                        height: hasImage ? 220 : 60,
                        color: const Color(0xFFEEEEEE),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Step content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step title (auto-generated from first few words)
                      Text(
                        _stepTitle(steps[i]),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Step description
                      Text(
                        steps[i],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMedium,
                          height: 1.5,
                        ),
                      ),

                      // Optional step image
                      if (hasImage) ...[
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            stepImages[i]!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Extract first 3-4 words as step title
  String _stepTitle(String step) {
    final words = step.trim().split(' ');
    if (words.length <= 4) return step;
    return words.take(4).join(' ');
  }
}
