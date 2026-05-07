import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/favorite_service.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Widgets/home_container.dart';
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

  //Set<String> _favoriteIds = {};
  final _favoriteIds = ValueNotifier<Set<String>>(<String>{});

  @override
  void initState() {
    super.initState();
    // ✅ favoritesStream subscribe karo — jab bhi change ho, setState
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
      backgroundColor: Color(0xFFFFF3DC),
      // AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: HomeHeader()),
          const HomeContainer(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
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
                  const SizedBox(height: 12),
                  CategoryRow(
                    onCategorySelected: (val) =>
                        setState(() => _selectedCategory = val),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
              child: Text('Popular Today', style: AppTheme.headingMedium),
            ),
          ),

          // Homepage mein sirf StreamBuilder wala part replace karo:
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

              // ✅ SliverList — single wide cards
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
                          // ✅ Naye fields
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
