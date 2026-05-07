import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Services/favorite_service.dart';
import 'package:smart_chef/Widgets/detail_chef.dart';
import 'package:smart_chef/Widgets/detail_ingridients.dart';
import 'package:smart_chef/Widgets/detail_steps.dart';
import 'package:smart_chef/Widgets/review_list.dart';
import 'package:smart_chef/Widgets/review_sheet.dart';
import 'package:smart_chef/widgets/detail_header.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const DetailPage({super.key, required this.recipe});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _favService = FavoriteService();
  bool _isFav = false;
  Map<String, dynamic>? _chefData;

  @override
  void initState() {
    super.initState();
    _loadChefData();
  }

  // ── Parse List<String> from Firestore ────────────
  List<String> _parseList(String key) {
    final val = widget.recipe[key];
    if (val == null) return [];
    if (val is List) return List<String>.from(val);
    return val.toString().split(',').map((e) => e.trim()).toList();
  }

  // ── Load fav status from FavoriteService ─────────
  // Future<void> _loadFavStatus() async {
  //   final docId = widget.recipe['docId'] as String?;
  //   if (docId == null) return;
  //   final isFav = await _favService.isFavorite(docId);
  //   if (mounted) setState(() => _isFav = isFav);
  // }

  // ── Load chef data from Users collection ─────────
  Future<void> _loadChefData() async {
    final userId = widget.recipe['userId'] as String?;
    if (userId == null || userId.isEmpty) return;
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get();
    if (doc.exists && mounted) {
      setState(() => _chefData = doc.data());
    }
  }

  // ── Toggle favourite ──────────────────────────────
  Future<void> _toggleFav() async {
    final docId = widget.recipe['docId'] as String?;
    if (docId == null) return;
    setState(() => _isFav = !_isFav);
    await _favService.toggleFavorite(docId);
  }

  @override
  Widget build(BuildContext context) {
    // ── Data from recipe map ──────────────────────
    final ingredients = _parseList('ingredients');
    final steps = _parseList('steps');
    final name = widget.recipe['name'] ?? '';
    final category = widget.recipe['category'] ?? '';
    final time = widget.recipe['time']?.toString() ?? '0';
    final rating = (widget.recipe['avgRating'] ?? 0).toDouble(); // ✅ avgRating
    final likes = widget.recipe['likes'] ?? 0;
    final difficulty = widget.recipe['difficulty'] ?? 'Easy';
    final description = widget.recipe['description'] ?? '';
    final image = widget.recipe['image'] ?? '';
    final docId = widget.recipe['docId'] as String?;

    // ── Chef info ─────────────────────────────────
    final chefName =
        _chefData?['name'] ?? widget.recipe['userName'] ?? 'Unknown Chef';
    final chefPhoto =
        _chefData?['imageUrl'] ?? widget.recipe['userPhoto'] ?? '';
    final chefLevel = _chefData?['level'] ?? 'Chef';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ───────────────────────────
          SliverToBoxAdapter(
            child: DetailHeader(
              imageUrl: image,
              name: name,
              category: category,
              time: time,
              rating: rating,
              reviews: likes,
              calories: '450 kcal',
              onBack: () => Navigator.pop(context),
              onSearch: () {},
              onProfile: () {},
            ),
          ),

          // ── Body ─────────────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                color: AppTheme.background,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Chef Card ───────────────────
                    ChefCard(
                      name: chefName,
                      photoUrl: chefPhoto,
                      level: chefLevel,
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textMedium,
                          height: 1.6,
                        ),
                      ),
                    ],
                    if (ingredients.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      IngredientsChecklist(ingredients: ingredients),
                    ],

                    // ── Cooking Steps ────────────────
                    if (steps.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      CookingSteps(steps: steps, difficulty: difficulty),
                    ],

                    // ── Reviews ─────────────────────
                    if (docId != null) ...[
                      const SizedBox(height: 28),
                      ReviewsList(recipeId: docId), // ✅ recipeId filter
                    ],

                    const SizedBox(height: 28),

                    // ── Action Buttons ───────────────

                    // Rate Recipe button
                    GestureDetector(
                      onTap: () {
                        if (docId == null) return;
                        ReviewSheet.show(context, docId, name);
                      },
                      child: Container(
                        height: 52,
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Rate Recipe',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
