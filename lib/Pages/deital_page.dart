import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Widgets/detail_ingridients.dart';
import 'package:smart_chef/Widgets/detail_steps.dart';

import 'package:smart_chef/widgets/detail_header.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const DetailPage({super.key, required this.recipe});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _isFav = widget.recipe['isFav'] ?? false;
  }

  // ── Safely parse List<String> from Firestore ──
  List<String> _parseList(String key) {
    final val = widget.recipe[key];
    if (val == null) return [];
    if (val is List) return List<String>.from(val);
    // Fallback: old string format — split by comma
    return val.toString().split(',').map((e) => e.trim()).toList();
  }

  Future<void> _toggleFav(String? docId) async {
    if (docId == null) return;
    setState(() => _isFav = !_isFav);
    await FirebaseFirestore.instance.collection('Receipes').doc(docId).update({
      'isFav': _isFav,
    });
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0, -28, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      const SizedBox(height: 24),
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

                    // ── Add to Favourite button ────────
                    GestureDetector(
                      onTap: () => _toggleFav(docId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 54,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 36),
                        decoration: BoxDecoration(
                          color: _isFav ? AppTheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppTheme.primary, width: 2),
                          boxShadow: _isFav
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: _isFav ? Colors.white : AppTheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isFav
                                  ? 'SAVED TO FAVOURITES'
                                  : 'ADD TO FAVOURITES',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _isFav ? Colors.white : AppTheme.primary,
                                letterSpacing: 0.6,
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
