import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

class IngredientsEditor extends StatefulWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final ValueChanged<int> onDelete;

  const IngredientsEditor({
    super.key,
    required this.controllers,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  State<IngredientsEditor> createState() => _IngredientsEditorState();
}

class _IngredientsEditorState extends State<IngredientsEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              GestureDetector(
                onTap: widget.onAdd,
                child: const Row(
                  children: [
                    Icon(Icons.add, color: AppTheme.primary, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'ADD ITEM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Ingredient fields
          ...List.generate(widget.controllers.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: widget.controllers[i],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: i == 0
                              ? '200g Flour'
                              : i == 1
                              ? '2 Large Eggs'
                              : 'Add ingredient...',
                          hintStyle: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => widget.onDelete(i),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
