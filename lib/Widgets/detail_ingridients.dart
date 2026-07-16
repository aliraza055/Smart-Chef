import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/ingredients_checklist_controller.dart';

class IngredientsChecklist extends StatelessWidget {
  final List<String> ingredients;
  final String _controllerTag;

  IngredientsChecklist({super.key, required this.ingredients})
    : _controllerTag =
          'ingredients_${ingredients.length}_${Object.hashAll(ingredients)}' {
    Get.put(
      IngredientsChecklistController(ingredients.length),
      tag: _controllerTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IngredientsChecklistController>(
      tag: _controllerTag,
    );

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
                  '${ingredients.length} ITEMS',
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
          ...List.generate(ingredients.length, (i) {
            return Obx(
              () => GestureDetector(
                onTap: () => controller.toggle(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: controller.checked[i]
                              ? AppTheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: controller.checked[i]
                                ? AppTheme.primary
                                : const Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: controller.checked[i]
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        ingredients[i],
                        style: TextStyle(
                          fontSize: 14,
                          color: controller.checked[i]
                              ? AppTheme.textLight
                              : AppTheme.textDark,
                          decoration: controller.checked[i]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

