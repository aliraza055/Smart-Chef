import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Models/toast_error.dart';
import 'package:smart_chef/Models/upload_recepies.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/image_picker.dart';
import 'package:smart_chef/Widgets/image_container.dart';

import 'package:smart_chef/widgets/category_selector.dart';

class AddReceipe extends StatefulWidget {
  const AddReceipe({super.key});

  @override
  State<AddReceipe> createState() => _AddReceipeState();
}

class _AddReceipeState extends State<AddReceipe> {
  File? _image;
  String? _selectedCategory;
  bool _isLoading = false;

  final randomTime = (10 + Random().nextInt(51)).toDouble();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Dynamic ingredients list
  final List<TextEditingController> _ingredientControllers = [];

  // Dynamic steps list
  final List<TextEditingController> _stepControllers = [];

  final _imagePicker = ImagePickerService();
  final User? _user = FirebaseAuth.instance.currentUser;

  static const List<String> _categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Vegan',
  ];

  @override
  void initState() {
    super.initState();
  }

  bool _validate() {
    if (_image == null) {
      ToastError().showToast(
        message: 'Please select a recipe photo',
        bgColor: Colors.red,
      );
      return false;
    }
    if (_titleController.text.trim().isEmpty) {
      ToastError().showToast(
        message: 'Please enter a recipe title',
        bgColor: Colors.red,
      );
      return false;
    }
    if (_selectedCategory == null) {
      ToastError().showToast(
        message: 'Please select a category',
        bgColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  Future<void> _publish() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);

    final List<String> ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final List<String> steps = _stepControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    await UploadRecepie().uploadReceipes(
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      user: _user,
      difficulty: ['easy', 'medium', 'hard'][Random().nextInt(3)],
      ingredients: ingredients,
      steps: steps,
      image: _image!,
      time: randomTime,
      createdAt: FieldValue.serverTimestamp(),
    );

    setState(() => _isLoading = false);
    Navigator.pushNamed(context, PageRouter.bottomNav);
    ToastError().showToast(
      message: 'Recipe Published Successfully! 🎉',
      bgColor: Colors.green,
    );
  }

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // ✅ AI Chef FAB yahan se REMOVE kar diya — ab HomePage mein hai
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppTheme.cardShadow, blurRadius: 8),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
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
            ),
          ),

          // ── Title ────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Recipe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Share your culinary masterpiece with the community.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Image Picker ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: RecipeImagePicker(
                image: _image,
                onTap: () async {
                  final picked = await _imagePicker.pickFromGallery();
                  if (picked != null) setState(() => _image = picked);
                },
              ),
            ),
          ),

          // ── Recipe Title Field ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RECIPE TITLE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: "e.g. Grandma's Secret Pasta",
                        hintStyle: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: CategorySelector(
                categories: _categories,
                selected: _selectedCategory,
                onSelected: (val) => setState(() => _selectedCategory = val),
              ),
            ),
          ),

          // ── Ingredients ──────────────────────────────

          // ── Preparation Steps ─────────────────────────

          // ── Action Buttons ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
              child: Row(
                children: [
                  // Save Draft
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ToastError().showToast(
                          message: 'Draft saved!',
                          bgColor: Colors.grey.shade700,
                        );
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1.8,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'SAVE DRAFT',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Publish
                  Expanded(
                    child: GestureDetector(
                      onTap: _isLoading ? null : _publish,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'PUBLISH RECIPE',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final c in _ingredientControllers) {
      c.dispose();
    }
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
