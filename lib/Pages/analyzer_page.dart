import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Controller/food_analyzer_controller.dart';
import 'package:smart_chef/Models/food_anlysis_model.dart';
import 'package:smart_chef/Utils/app_responsive.dart';
import 'package:smart_chef/Widgets/neutrition_card.dart';

/// GetView<FoodAnalyzerController> ka fayda: `controller` getter is
/// class ke KISI BHI method mein available hai (sirf build() mein
/// nahi) — is wajah se helper methods (_buildHeader waghera) purane
/// jaisa structure rakh sakte hain, bas `controller.xxx` access karo.
class FoodAnalyzerScreen extends GetView<FoodAnalyzerController> {
  const FoodAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FoodAnalyzerController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.horizontalPadding(context, size: 20),
                AppResponsive.height(context, 28),
                AppResponsive.horizontalPadding(context, size: 20),
                0,
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'UPLOAD FOOD IMAGE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildImageSection(context),
                  const SizedBox(height: 16),

                  Obx(() {
                    if (controller.isAnalyzing.value) {
                      return _buildLoadingState();
                    }
                    if (controller.analysis.value != null) {
                      return _buildResults(controller.analysis.value!);
                    }
                    return _buildAnalyzeButton();
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.horizontalPadding(context, size: 20),
        AppResponsive.height(context, 56),
        AppResponsive.horizontalPadding(context, size: 20),
        AppResponsive.height(context, 28),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back / Refresh button
          Obx(
            () => GestureDetector(
              onTap: controller.analysis.value != null
                  ? controller.reset
                  : () => Get.back(),
              child: Container(
                width: AppResponsive.width(context, 40),
                height: AppResponsive.height(context, 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.analysis.value != null
                      ? Icons.refresh
                      : Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.height(context, 20)),

          // AI badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFF5A623), size: 14),
                SizedBox(width: 6),
                Text(
                  'AI POWERED',
                  style: TextStyle(
                    color: Color(0xFFF5A623),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'Food Analyzer',
            style: TextStyle(
              fontSize: AppResponsive.text(context, 30),
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Snap your meal and get full\nnutritional breakdown instantly',
            style: TextStyle(
              fontSize: AppResponsive.text(context, 14),
              color: Colors.white60,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => _showPickerDialog(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: AppResponsive.height(context, 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primary.withOpacity(0.5),
              width: 1.5,
            ),
            color: const Color(0xFFF2F2F2),
          ),
          child: controller.selectedImage.value != null
              ? _buildSelectedImage()
              : _buildEmptyState(context),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: AppResponsive.width(context, 72),
          height: AppResponsive.height(context, 72),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2d6a4f).withOpacity(0.25),
            border: Border.all(
              color: const Color(0xFF7ecba1).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 30,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap to capture or upload',
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'JPG, PNG · Max 10MB',
          style: TextStyle(color: AppTheme.primary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SourcePill(icon: Icons.camera_alt_rounded, label: 'Camera'),
            const SizedBox(width: 8),
            _SourcePill(icon: Icons.photo_library_outlined, label: 'Gallery'),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(controller.selectedImage.value!, fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 12, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

  void _showPickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a2f22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF7ecba1)),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF7ecba1),
              ),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: controller.selectedImage.value != null
              ? controller.analyzeImage
              : null,
          icon: const Icon(Icons.auto_awesome, color: Colors.white),
          label: const Text(
            'Analyze with AI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2d6a4f),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.black38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ScaleTransition(
      scale: controller.pulseAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1a2f22),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF7ecba1),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                controller.loadingMessage.value,
                style: const TextStyle(color: Color(0xFF7ecba1), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(FoodAnalysis a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Food name card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1a2f22),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.foodName,
                      style: const TextStyle(
                        color: Color(0xFF7ecba1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      a.cuisineType,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Serving: ${a.servingSize}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              HealthScoreRing(score: a.healthScore),
            ],
          ),
        ),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
          children: [
            NutrientCard(
              label: 'kcal',
              value: '${a.calories}',
              color: const Color(0xFFFF6B6B),
            ),
            NutrientCard(
              label: 'Protein',
              value: '${a.protein}g',
              color: const Color(0xFF7ecba1),
            ),
            NutrientCard(
              label: 'Carbs',
              value: '${a.carbs}g',
              color: const Color(0xFFFFC107),
            ),
            NutrientCard(
              label: 'Fat',
              value: '${a.fat}g',
              color: const Color(0xFF64B5F6),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailedNutrients(a),
        const SizedBox(height: 12),

        _buildTags(a),
        const SizedBox(height: 12),

        _buildTips(a),
      ],
    );
  }

  Widget _buildDetailedNutrients(FoodAnalysis a) {
    final nutrients = [
      {'label': 'Fiber', 'value': a.fiber, 'max': 30.0, 'unit': 'g'},
      {'label': 'Sugar', 'value': a.sugar, 'max': 50.0, 'unit': 'g'},
      {'label': 'Sodium', 'value': a.sodium, 'max': 2300.0, 'unit': 'mg'},
      {'label': 'Vitamin C', 'value': a.vitaminC, 'max': 90.0, 'unit': 'mg'},
      {'label': 'Iron', 'value': a.iron, 'max': 18.0, 'unit': 'mg'},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2f22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Nutrients',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ...nutrients.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        n['label'] as String,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${n['value']}${n['unit']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: ((n['value'] as double) / (n['max'] as double))
                        .clamp(0, 1),
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF7ecba1)),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(FoodAnalysis a) {
    final allTags = [
      ...a.allergens.map((e) => ('⚠ $e', Colors.orange.shade400)),
      ...a.dietTags.map((e) => (e, const Color(0xFF7ecba1))),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allTags
          .map(
            (t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: t.$2.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: t.$2.withOpacity(0.4)),
              ),
              child: Text(t.$1, style: TextStyle(color: t.$2, fontSize: 12)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTips(FoodAnalysis a) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2f22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFF7ecba1), size: 16),
              SizedBox(width: 8),
              Text(
                'Health Tips',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...a.healthTips.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2d6a4f),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.5,
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
}

class _SourcePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SourcePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
