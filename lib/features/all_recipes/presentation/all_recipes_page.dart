import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/core/constants/app_theme.dart';
import 'package:smart_chef/core/routes/page_router.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';
import 'package:smart_chef/features/all_recipes/controllers/all_recipes_controller.dart';
import 'package:smart_chef/features/favorites/presentation/widgets/favorite_card.dart';

class AllRecipesPage extends StatelessWidget {
  const AllRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AllRecipesController controller = Get.put(AllRecipesController());

    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header & Search Bar ─────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 56),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: AppResponsive.width(context, 40),
                      height: AppResponsive.height(context, 40),
                      decoration: BoxDecoration(
                        color: AppTheme.getSurface(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.getCardShadow(context),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: AppResponsive.height(context, 46),
                      decoration: BoxDecoration(
                        color: AppTheme.getSurface(context),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.getCardShadow(context),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.getTextDark(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search recipes...',
                          hintStyle: TextStyle(
                            color: AppTheme.getTextLight(context),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: AppTheme.getTextLight(context),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: controller.updateQuery,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (controller.query.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: controller.clearQuery,
                        child: Container(
                          width: AppResponsive.width(context, 36),
                          height: AppResponsive.height(context, 36),
                          decoration: BoxDecoration(
                            color: AppTheme.getSurface(context),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: AppTheme.getTextMedium(context),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // ── Title Section ───────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 24),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Recipes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.getTextDark(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explore our complete collection of delicious recipes.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.getTextMedium(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Recipes Grid (FavoritePage layout) ──
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
              );
            }

            final recipes = controller.filteredRecipes;

            if (recipes.isEmpty) {
              return SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        color: AppTheme.primary,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No recipes found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.getTextDark(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try searching for something else!',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.getTextMedium(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            final favSet = controller.favoriteIds.toSet();

            return SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 20),
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 30),
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final data = recipes[index];
                  final docId = data['docId'] ?? '';

                  return FavoriteCard(
                    image: data['image'] ?? '',
                    name: data['name'] ?? '',
                    description: data['description'] ?? '',
                    time: data['time']?.toString() ?? '',
                    likes: data['likes']?.toString() ?? '0',
                    isFavorite: favSet.contains(docId),
                    tag: data['category'] ?? '',
                    onTap: () =>
                        Get.toNamed(PageRouter.detailPage, arguments: data),
                    onFavoriteToggle: () => controller.toggleFavorite(docId),
                  );
                }, childCount: recipes.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.70,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
