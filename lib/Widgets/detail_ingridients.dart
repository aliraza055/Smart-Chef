import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

class IngredientsChecklist extends StatefulWidget {
  final List<String> ingredients;

  const IngredientsChecklist({super.key, required this.ingredients});

  @override
  State<IngredientsChecklist> createState() => _IngredientsChecklistState();
}

class _IngredientsChecklistState extends State<IngredientsChecklist> {
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.ingredients.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.ingredients.length} ITEMS',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Ingredient rows
          ...List.generate(widget.ingredients.length, (i) {
            return GestureDetector(
              onTap: () => setState(() => _checked[i] = !_checked[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _checked[i]
                            ? AppTheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: _checked[i]
                              ? AppTheme.primary
                              : const Color(0xFFCCCCCC),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _checked[i]
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      widget.ingredients[i],
                      style: TextStyle(
                        fontSize: 14,
                        color: _checked[i]
                            ? AppTheme.textLight
                            : AppTheme.textDark,
                        decoration: _checked[i]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
