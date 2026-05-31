import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Models/food_anlysis_model.dart';
import 'package:smart_chef/Services/food_analyzer_services.dart';
import 'package:smart_chef/Widgets/neutrition_card.dart';

class FoodAnalyzerScreen extends StatefulWidget {
  const FoodAnalyzerScreen({super.key});

  @override
  State<FoodAnalyzerScreen> createState() => _FoodAnalyzerScreenState();
}

class _FoodAnalyzerScreenState extends State<FoodAnalyzerScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  FoodAnalysis? _analysis;
  bool _isAnalyzing = false;
  String _loadingMessage = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _loadingMessages = [
    'Identifying food item...',
    'Calculating nutrients...',
    'Checking allergens...',
    'Generating health tips...',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _analysis = null;
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;
    setState(() {
      _isAnalyzing = true;
      _loadingMessage = _loadingMessages[0];
    });

    // Cycle through loading messages
    for (int i = 1; i < _loadingMessages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _loadingMessage = _loadingMessages[i]);
    }

    try {
      final result = await AiServiceImage.analyzeFoodImage(_selectedImage!);
      setState(() {
        _analysis = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
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
                  _buildImageSection(),
                  const SizedBox(height: 16),
                  if (_analysis == null && !_isAnalyzing) _buildAnalyzeButton(),
                  if (_isAnalyzing) _buildLoadingState(),
                  if (_analysis != null) _buildResults(),
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
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)],
        ),
        //  color: AppTheme.headerBg,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back / Refresh button
          GestureDetector(
            onTap: _analysis != null
                ? () => setState(() {
                    _selectedImage = null;
                    _analysis = null;
                  })
                : () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _analysis != null
                    ? Icons.refresh
                    : Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

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

          const Text(
            'Food Analyzer',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Snap your meal and get full\nnutritional breakdown instantly',
            style: TextStyle(fontSize: 14, color: Colors.white60, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _showPickerDialog,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF7ecba1).withOpacity(0.3),
            width: 4,
          ),
          color: Color(0xFF7ecba1).withOpacity(0.1),
        ),
        child: _selectedImage != null
            ? _buildSelectedImage()
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon circle with subtle border
        Container(
          width: 72,
          height: 72,
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
            color: Color(0xFF7ecba1),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Tap to capture or upload',
          style: TextStyle(
            color: Color(0xFF7ecba1),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        const Text(
          'JPG, PNG · Max 10MB',
          style: TextStyle(color: Color(0xFF7ecba1), fontSize: 12),
        ),
        const SizedBox(height: 16),

        // Camera / Gallery pills
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
          Image.file(_selectedImage!, fit: BoxFit.cover),
          // Dark gradient at bottom
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

  void _showPickerDialog() {
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
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
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
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _selectedImage != null ? _analyzeImage : null,
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
    );
  }

  Widget _buildLoadingState() {
    return ScaleTransition(
      scale: _pulseAnimation,
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
            Text(
              _loadingMessage,
              style: const TextStyle(color: Color(0xFF7ecba1), fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final a = _analysis!;
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

        // Macro grid
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

        // Detailed nutrients
        _buildDetailedNutrients(a),
        const SizedBox(height: 12),

        // Tags (allergens + diet)
        _buildTags(a),
        const SizedBox(height: 12),

        // Tips
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
        color: const Color(0xFF2d6a4f).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7ecba1).withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF7ecba1).withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7ecba1),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
