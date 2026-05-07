import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/favorite_service.dart';
import 'package:smart_chef/Widgets/favorite_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header (same as before) ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Smart Chef',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Title (same as before) ───────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Favourites',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Recipes you love, all in one place.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
                  ),
                ],
              ),
            ),
          ),

          // ── Recipe Grid ─────────────────────────────
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _favoriteService
                .getFavoriteRecipesStream(), // ✅ user-specific stream
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                );
              }

              final recipes = snapshot.data ?? [];

              if (recipes.isEmpty) {
                return SliverFillRemaining(child: _EmptyFavourites());
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = recipes[index];

                    return FavoriteCard(
                      image: data['image'] ?? '',
                      name: data['name'] ?? '',
                      description: data['description'] ?? '',

                      //      tag: data['category'] ?? '',
                      time: data['category'] ?? '',
                      likes: data['likes']?.toString() ?? '0',
                      isFavorite: true, // ✅ yahan sab favorites hain
                      tag: data['tag'] ?? '',
                      onTap: () => Navigator.pushNamed(
                        context,
                        PageRouter.detailPage,
                        arguments: data, // docId already andar hai
                      ),
                      onFavoriteToggle: () async {
                        // ✅ toggle se remove ho jayega
                        await _favoriteService.toggleFavorite(data['docId']);
                      },
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
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            color: AppTheme.primary,
            size: 42,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No favourites yet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap the ♥ on any recipe\nto save it here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textMedium,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              'Explore Recipes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
