import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/features/ai_recipe/controllers/ai_recipe_generator_controller.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';

class AiRecipeGeneratorPage extends StatelessWidget {
  AiRecipeGeneratorPage({super.key});

  final controller = Get.put(AiRecipeGeneratorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),

          SliverToBoxAdapter(child: _buildIngredientInput(context)),

          Obx(
            () => controller.ingredients.isNotEmpty
                ? SliverToBoxAdapter(child: _buildChips())
                : const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          SliverToBoxAdapter(child: _buildGenerateButton()),

          Obx(() {
            if (controller.errorMessage.value.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverToBoxAdapter(child: _buildError());
          }),

          Obx(
            () => controller.isLoading.value
                ? SliverToBoxAdapter(child: _buildLoadingCard(context))
                : const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          Obx(
            () => controller.result.value != null && !controller.isLoading.value
                ? SliverToBoxAdapter(child: _buildResultCard(context))
                : const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.horizontalPadding(context, size: 20),
        AppResponsive.height(context, 56),
        AppResponsive.horizontalPadding(context, size: 20),
        AppResponsive.height(context, 28),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: AppResponsive.width(context, 40),
              height: AppResponsive.height(context, 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // AI sparkle badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFF5A623), size: 14),
                SizedBox(width: 6),
                Text(
                  'AI POWERED',
                  style: TextStyle(
                    color: Color(0xFFF5A623),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'Recipe Generator',
            style: TextStyle(
              fontSize: AppResponsive.text(context, 30),
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us the ingredients you have,\nand AI will create a recipe for you!',
            style: TextStyle(
              fontSize: AppResponsive.text(context, 14),
              color: Colors.white60,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ENTER YOUR INGREDIENTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.getCardShadow(context),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.ingredientController,
                    onSubmitted: (_) => controller.addIngredient(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.getTextDark(context),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'e.g. chicken, tomatoes, garlic...',
                      hintStyle: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.kitchen_outlined,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: controller.addIngredient,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'After entering an ingredient, press + or Enter.',
            style: TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${controller.ingredients.length} ingredient${controller.ingredients.length > 1 ? 's' : ''} added',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.ingredients
                  .map(
                    (item) => _IngredientChip(
                      label: item,
                      onDelete: () => controller.removeIngredient(item),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: ScaleTransition(
          scale: const AlwaysStoppedAnimation(1.0),
          child: GestureDetector(
            onTap: controller.isLoading.value || controller.ingredients.isEmpty
                ? null
                : controller.generate,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: controller.ingredients.isEmpty
                    ? const LinearGradient(
                        colors: [Color(0xFFCCCCCC), Color(0xFFBBBBBB)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: controller.ingredients.isEmpty
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.45),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    controller.isLoading.value
                        ? 'AI is creating a recipe...'
                        : 'Create a recipe with AI',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFCDD2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(fontSize: 13, color: AppTheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: AppTheme.cardShadow, blurRadius: 16),
          ],
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: AppTheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'AI chef is creating your recipe...',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              controller.ingredients.join(' • '),
              style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    final r = controller.result.value!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.headerBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFF5A623),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'AI GENERATED RECIPE',
                        style: TextStyle(
                          color: Color(0xFFF5A623),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      _DifficultyBadge(difficulty: r.difficulty),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    r.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  _MetaChip(
                    icon: Icons.access_time_rounded,
                    label: '${r.time.toInt()} min',
                  ),
                  const SizedBox(width: 10),
                  _MetaChip(icon: Icons.restaurant_menu, label: r.category),
                  const SizedBox(width: 10),
                  _MetaChip(
                    icon: Icons.kitchen_outlined,
                    label: '${r.ingredients.length} items',
                  ),
                ],
              ),
            ),
            _SectionTitle(title: 'Ingredients', count: r.ingredients.length),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: r.ingredients
                    .asMap()
                    .entries
                    .map(
                      (e) => _ListItem(
                        index: e.key + 1,
                        text: e.value,
                        isStep: false,
                      ),
                    )
                    .toList(),
              ),
            ),
            _SectionTitle(title: 'Steps', count: r.steps.length),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: r.steps
                    .asMap()
                    .entries
                    .map(
                      (e) => _ListItem(
                        index: e.key + 1,
                        text: e.value,
                        isStep: true,
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: controller.generate,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.primary, width: 1.8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: AppTheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Regenerate Recipe',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Helper Widgets
// ─────────────────────────────────────────────────────────────

class _IngredientChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const _IngredientChip({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = difficulty == 'easy'
        ? const Color(0xFF2D6A4F)
        : difficulty == 'medium'
        ? const Color(0xFFF5A623)
        : const Color(0xFFD62828);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;

  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final int index;
  final String text;
  final bool isStep;

  const _ListItem({
    required this.index,
    required this.text,
    required this.isStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isStep
                  ? AppTheme.primary
                  : AppTheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isStep ? Colors.white : AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMedium,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
