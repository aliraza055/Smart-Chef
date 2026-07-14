import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Controller/home_page_controller.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Widgets/analyzer_banner.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Utils/app_responsive.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';
import 'package:smart_chef/Widgets/upper_contanier.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      floatingActionButton: FloatingActionButton.extended(
        heroTag: "home_ai_chef",
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
        label: const Text(
          'AI Chef',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, PageRouter.receipeAi);
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────
          const SliverToBoxAdapter(child: HomeHeader()),
          SliverToBoxAdapter(
            child: AnalyzerBanner(
              onTap: () {
                Navigator.pushNamed(context, PageRouter.foodAnalyser);
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                0,
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Categories', style: AppTheme.headingMedium),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'SEE ALL',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyCategories(
              selectedCategory: controller.selectedCategory.value,
              onCategorySelected: controller.selectCategory,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 28),
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 16),
              ),
              child: Text('Popular Today', style: AppTheme.headingMedium),
            ),
          ),

          Obx(
            () => StreamBuilder<QuerySnapshot>(
              stream: controller.getRecipesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No recipes found!',
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                  );
                }

                final recipes = snapshot.data!.docs;

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.horizontalPadding(context, size: 20),
                    0,
                    AppResponsive.horizontalPadding(context, size: 20),
                    AppResponsive.height(context, 30),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final data =
                          recipes[index].data() as Map<String, dynamic>;
                      final docId = recipes[index].id;

                      return Obx(() {
                        final favIds = controller.favoriteIds.toSet();
                        return RecipeCard(
                          image: data['image'] ?? '',
                          name: data['name'] ?? '',
                          description: data['description'] ?? '',
                          time: data['time']?.toString() ?? '',
                          likes: data['likes']?.toString() ?? '0',
                          avgRating: (data['avgRating'] ?? 0.0).toStringAsFixed(
                            1,
                          ),
                          totalReviews: data['totalReviews']?.toString() ?? '0',
                          userName: data['userName'] ?? '',
                          tag: data['category'] ?? '',
                          isFavorite: favIds.contains(docId),
                          onFavoriteToggle: () =>
                              controller.toggleFavorite(docId),
                          onTap: () => Navigator.pushNamed(
                            context,
                            PageRouter.detailPage,
                            arguments: {...data, 'docId': docId},
                          ),
                        );
                      });
                    }, childCount: recipes.length),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyCategories extends SliverPersistentHeaderDelegate {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  _StickyCategories({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const double _height = 56.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _height,
      color: AppTheme.background,
      padding: const EdgeInsets.only(left: 20),
      child: CategoryRow(onCategorySelected: onCategorySelected),
    );
  }

  @override
  bool shouldRebuild(_StickyCategories oldDelegate) =>
      oldDelegate.selectedCategory != selectedCategory;
}
