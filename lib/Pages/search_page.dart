import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Constants/app_theme.dart';
import 'package:smart_chef/Controller/search_controller.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Utils/app_responsive.dart';
import 'package:smart_chef/Widgets/favorite_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.put(SearchPageController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.only(
              top:
                  MediaQuery.of(context).padding.top +
                  AppResponsive.height(context, 12),
              left: AppResponsive.horizontalPadding(context, size: 20),
              right: AppResponsive.horizontalPadding(context, size: 20),
              bottom: AppResponsive.height(context, 16),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: AppResponsive.width(context, 40),
                    height: AppResponsive.height(context, 40),
                    decoration: const BoxDecoration(
                      color: AppTheme.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 🔍 Search Field — TextEditingController controller
                // ke andar rehta hai (dispose bhi wahin hota hai)
                Expanded(
                  child: Container(
                    height: AppResponsive.height(context, 48),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search recipes...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppTheme.textLight,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: controller.updateQuery,
                    ),
                  ),
                ),

                Obx(
                  () => controller.query.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: controller.clearQuery,
                            child: Container(
                              width: AppResponsive.width(context, 36),
                              height: AppResponsive.height(context, 36),
                              decoration: const BoxDecoration(
                                color: AppTheme.background,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppTheme.textMedium,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // ── Results ─────────────────────────────
          Expanded(
            child: Obx(() {
              // `query.value` aur `allRecipes.isEmpty` dono seedhe
              // is Obx ke andar read ho rahe hain (synchronous),
              // isliye dono sources (search text change + naya
              // recipe Firestore mein add hona) par ye rebuild hoga.
              final q = controller.query.value;

              if (q.isEmpty) {
                return const _EmptySearch(query: '');
              }

              final all = controller.allRecipes;
              if (all.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                );
              }

              final filtered = SearchPageController.filterRecipes(q, all);

              if (filtered.isEmpty) {
                return _EmptySearch(query: q);
              }

              return GridView.builder(
                padding: EdgeInsets.all(
                  AppResponsive.horizontalPadding(context, size: 20),
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final data = filtered[index];
                  final docId = data['docId'] as String;

                  // Chhota nested Obx sirf favorite-heart ke liye:
                  // jab toggle ho, sirf yehi card rebuild hota hai,
                  // poora grid nahi.
                  return Obx(
                    () => FavoriteCard(
                      image: data['image'] ?? '',
                      name: data['name'] ?? '',
                      description: data['description'] ?? '',
                      time: data['time']?.toString() ?? '',
                      likes: data['avgRating']?.toString() ?? '0',
                      tag: data['category'] ?? '',
                      isFavorite: controller.favoriteIds.contains(docId),
                      onTap: () => Get.toNamed(
                        PageRouter.detailPage,
                        arguments: {...data, 'docId': docId},
                      ),
                      onFavoriteToggle: () => controller.toggleFavorite(docId),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────
class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              Icons.search_off_rounded,
              size: 38,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'Search recipes...' : 'No results for "$query"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different name or category',
            style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
          ),
        ],
      ),
    );
  }
}

