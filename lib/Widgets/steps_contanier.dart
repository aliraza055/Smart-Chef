import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

class PreparationStepsEditor extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final ValueChanged<int> onDelete;

  const PreparationStepsEditor({
    super.key,
    required this.controllers,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preparation Steps',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 14),

        // Steps list
        ...List.generate(controllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number badge
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(top: 12, right: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D5A27), // dark green like design
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Text area
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: controllers[i],
                      maxLines: 3,
                      minLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Describe the first step...',
                        hintStyle: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // Add another step button
        GestureDetector(
          onTap: onAdd,
          child: Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppTheme.textMedium,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'ADD ANOTHER STEP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMedium,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
