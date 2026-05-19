import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Widgets/detail_chef.dart';
import 'package:smart_chef/Widgets/detail_ingridients.dart';
import 'package:smart_chef/Widgets/detail_steps.dart';
import 'package:smart_chef/Widgets/nutertion_section.dart';
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
  Map<String, dynamic>? _chefData;

  @override
  void initState() {
    super.initState();
    _loadChefData();
  }

  List<String> _parseList(String key) {
    final val = widget.recipe[key];
    if (val == null) return [];
    if (val is List) return List<String>.from(val);
    return val.toString().split(',').map((e) => e.trim()).toList();
  }

  Future<void> _loadChefData() async {
    final userId = widget.recipe['userUid'] as String?;
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get();
    if (doc.exists && mounted) {
      setState(() => _chefData = doc.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _parseList('ingredients');
    final steps = _parseList('steps');
    final name = widget.recipe['name'] ?? '';
    final category = widget.recipe['category'] ?? '';
    final time = widget.recipe['time']?.toString() ?? '0';
    final rating = (widget.recipe['avgRating'] ?? 0).toDouble();
    final likes = widget.recipe['likes'] ?? 0;
    final difficulty = widget.recipe['difficulty'] ?? 'Easy';
    final description = widget.recipe['description'] ?? '';
    final image = widget.recipe['image'] ?? '';
    final docId = widget.recipe['docId'] as String?;

    final chefName = _chefData?['name'] ?? 'Unknown Chef';
    final chefPhoto =
        _chefData?['imageUrl'] ?? widget.recipe['userPhoto'] ?? '';
    final chefLevel = _chefData?['gmail'] ?? 'Chef';

    return Scaffold(
      backgroundColor: AppTheme.background,

      // ── ✅ Sticky Rate Recipe Button ──────────────────────────────────────
      bottomNavigationBar: docId != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: GestureDetector(
                  onTap: () => ReviewSheet.show(context, docId, name),
                  child: Container(
                    height: 54,
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
                        Icon(Icons.star_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Rate Recipe',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ─────────────────────────────────────────────────
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

          // ── Body ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                color: AppTheme.background,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Chef Card ──────────────────────────────────────────
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

                    if (steps.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      CookingSteps(steps: steps, difficulty: difficulty),
                    ],

                    // ── 🤖 AI Nutrition Section ────────────────────────────
                    if (ingredients.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      NutritionSection(ingredients: ingredients),
                    ],

                    if (docId != null) ...[
                      const SizedBox(height: 28),
                      ReviewsList(recipeId: docId),
                    ],

                    // ✅ Extra bottom padding so last content isn't hidden
                    // behind the sticky button
                    const SizedBox(height: 20),
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
