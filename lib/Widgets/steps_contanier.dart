import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_theme.dart';

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
        Text(
          'Preparation Steps',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.getTextDark(context),
          ),
        ),
        const SizedBox(height: 14),

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
                      color: AppTheme.getSurface(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.getDivider(context),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: controllers[i],
                      maxLines: 3,
                      minLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.getTextDark(context),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Describe the first step...',
                        hintStyle: TextStyle(
                          color: AppTheme.getTextLight(context),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppTheme.getTextMedium(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'ADD ANOTHER STEP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.getTextMedium(context),
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

