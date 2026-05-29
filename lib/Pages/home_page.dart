import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Pages/ai_receipeGenrateor.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/favorite_service.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';
import 'package:smart_chef/Widgets/upper_contanier.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _selectedCategory = 'All';

  final _favService = FavoriteService();
  final _favoriteIds = ValueNotifier<Set<String>>(<String>{});

  @override
  void initState() {
    super.initState();
    _favService.favoritesStream().listen((ids) {
      if (mounted) _favoriteIds.value = ids;
    });
  }

  Stream<QuerySnapshot> _getRecipesStream() {
    final col = FirebaseFirestore.instance.collection('Receipes');
    if (_selectedCategory == 'All') return col.snapshots();
    return col.where('category', isEqualTo: _selectedCategory).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // ── AI Chef FAB ──────────────────────────────────────────
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
          MaterialPageRoute(builder: (_) => const AiRecipeGeneratorPage());
        },
      ),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────
          const SliverToBoxAdapter(child: HomeHeader()),

          // ── Categories heading ───────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
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

          // ── Sticky Category Row ──────────────────────────────
          SliverPersistentHeader(
            pinned: true, // ← yahi sticky banata hai
            delegate: _StickyCategories(
              selectedCategory: _selectedCategory,
              onCategorySelected: (val) =>
                  setState(() => _selectedCategory = val),
            ),
          ),

          // ── Popular Today heading ────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
              child: Text('Popular Today', style: AppTheme.headingMedium),
            ),
          ),

          // ── Recipes List ─────────────────────────────────────
          StreamBuilder<QuerySnapshot>(
            stream: _getRecipesStream(),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = recipes[index].data() as Map<String, dynamic>;
                    final docId = recipes[index].id;

                    return ValueListenableBuilder<Set<String>>(
                      valueListenable: _favoriteIds,
                      builder: (context, favIds, _) {
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
                              _favService.toggleFavorite(docId),
                          onTap: () => Navigator.pushNamed(
                            context,
                            PageRouter.detailPage,
                            arguments: {...data, 'docId': docId},
                          ),
                        );
                      },
                    );
                  }, childCount: recipes.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Sticky Category Delegate ─────────────────────────────────────────────────
class _StickyCategories extends SliverPersistentHeaderDelegate {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  _StickyCategories({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  // Category row ki height — apni CategoryRow ki actual height ke hisaab se adjust karo
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
      color: AppTheme.background, // scroll ke peeche white background
      padding: const EdgeInsets.only(left: 20),
      child: CategoryRow(
        onCategorySelected: onCategorySelected,
        // agar CategoryRow mein selected pass hoti ho to yeh bhi add karo:
        // selectedCategory: selectedCategory,
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyCategories oldDelegate) =>
      oldDelegate.selectedCategory != selectedCategory;
}
