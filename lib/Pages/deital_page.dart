import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Widgets/detail_chef.dart';
import 'package:smart_chef/Widgets/detail_ingridients.dart';
import 'package:smart_chef/Widgets/detail_steps.dart';
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

  // ── Safely parse List<String> from Firestore ──
  List<String> _parseList(String key) {
    final val = widget.recipe[key];
    if (val == null) return [];
    if (val is List) return List<String>.from(val);
    // Fallback: old string format — split by comma
    return val.toString().split(',').map((e) => e.trim()).toList();
  }

  Future<void> _getReviews() async {
    final data = await FirebaseFirestore.instance
        .collection('Reviews')
        .where('receipeId', isEqualTo: widget.recipe['docId'])
        .get();
  }

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

  @override
  Widget build(BuildContext context) {
    final ingredients = _parseList('ingredients');
    final steps = _parseList('steps');
    final name = widget.recipe['name'] ?? '';
    final category = widget.recipe['category'] ?? '';
    final time = widget.recipe['time']?.toString() ?? '0';
    final rating = (widget.recipe['rating'] ?? 0).toDouble();
    final likes = widget.recipe['likes'] ?? 0;
    final difficulty = widget.recipe['difficulty'] ?? 'Easy';
    final description = widget.recipe['description'] ?? '';
    final image = widget.recipe['image'] ?? '';
    final docId = widget.recipe['docId'] as String?;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Image Header ──────────────────────
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

          // ── White card body ────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.background,
                // borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0, -28, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChefCard(
                      name:
                          _chefData?['name'] ??
                          widget.recipe['userName'] ??
                          'Unknown Chef',
                      photoUrl:
                          _chefData?['imageUrl'] ??
                          widget.recipe['userPhoto'] ??
                          '',
                      level: _chefData?['level'] ?? 'Chef',
                    ),
                    SizedBox(height: 20),
                    // ── Description (if any) ──────────
                    if (description.isNotEmpty) ...[
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textMedium,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Ingredients checklist ──────────
                    if (ingredients.isNotEmpty) ...[
                      IngredientsChecklist(ingredients: ingredients),
                      const SizedBox(height: 28),
                    ],

                    // ── Cooking Steps ──────────────────
                    if (steps.isNotEmpty) ...[
                      CookingSteps(steps: steps, difficulty: difficulty),
                      const SizedBox(height: 24),
                    ],
                    ReviewSheet(
                      recipeId: widget.recipe['docId'],
                      recipeName: widget.recipe['name'] ?? '',
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
