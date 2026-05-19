import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Services/nutertion_services.dart';

// ─────────────────────────────────────────────────────────────
//  NutritionSection
//  Usage:
//    NutritionSection(ingredients: ingredients)
//
//  - "Analyze" button tap karo → Claude AI se estimate aata hai
//  - Calories, Protein, Carbs, Fat, Fiber cards mein show hote hain
//  - Per-ingredient breakdown bhi show hota hai
// ─────────────────────────────────────────────────────────────

class NutritionSection extends StatefulWidget {
  final List<String> ingredients;

  const NutritionSection({super.key, required this.ingredients});

  @override
  State<NutritionSection> createState() => _NutritionSectionState();
}

class _NutritionSectionState extends State<NutritionSection>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _hasAnalyzed = false;
  NutritionResult? _result;
  String? _error;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // nutrition_section.dart mein _analyze() ko yeh se replace karo:
  Future<void> _analyze() async {
    if (widget.ingredients.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await NutritionService().estimate(widget.ingredients);
      setState(() {
        _result = result;
        _isLoading = false;
        _hasAnalyzed = true;
      });
      _fadeController.forward(from: 0);
    } catch (e) {
      print('🔴 NUTRITION ERROR: $e'); // <-- yeh add karo
      setState(() {
        _error = e.toString(); // <-- exact error UI pe dikhao
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF52B788),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Nutrition Info',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF52B788).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 10, color: Color(0xFF52B788)),
                  SizedBox(width: 4),
                  Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF52B788),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ── Analyze Button (initial state) ──────────────────
        if (!_hasAnalyzed && !_isLoading)
          _AnalyzeButton(
            ingredientCount: widget.ingredients.length,
            onTap: _analyze,
          ),

        // ── Loading ─────────────────────────────────────────
        if (_isLoading) const _LoadingCard(),

        // ── Error ───────────────────────────────────────────
        if (_error != null) _ErrorCard(message: _error!),

        // ── Results ─────────────────────────────────────────
        if (_result != null && !_isLoading)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _ResultCard(result: _result!, onReAnalyze: _analyze),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Analyze Button
// ─────────────────────────────────────────────────────────────
class _AnalyzeButton extends StatelessWidget {
  final int ingredientCount;
  final VoidCallback onTap;

  const _AnalyzeButton({required this.ingredientCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF52B788), Color(0xFF40916C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF52B788).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monitor_heart_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Nutrition Analysis',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$ingredientCount ingredients se calories, protein, carbs estimate karo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Loading Card
// ─────────────────────────────────────────────────────────────
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: AppTheme.cardShadow, blurRadius: 12),
        ],
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Color(0xFF52B788),
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(width: 16),
          Text(
            'AI nutrition calculate kar raha hai...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Error Card
// ─────────────────────────────────────────────────────────────
class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Result Card
// ─────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final NutritionResult result;
  final VoidCallback onReAnalyze;

  const _ResultCard({required this.result, required this.onReAnalyze});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppTheme.cardShadow, blurRadius: 16),
        ],
      ),
      child: Column(
        children: [
          // ── Green header ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF52B788), Color(0xFF40916C)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.calories} kcal',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      result.servingNote,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'AI Estimated',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Macro grid ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    _MacroCard(
                      label: 'Protein',
                      value: '${result.protein.toStringAsFixed(1)}g',
                      color: const Color(0xFF4A90D9),
                      icon: Icons.fitness_center_rounded,
                    ),
                    const SizedBox(width: 10),
                    _MacroCard(
                      label: 'Carbs',
                      value: '${result.carbs.toStringAsFixed(1)}g',
                      color: const Color(0xFFF5A623),
                      icon: Icons.grain_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MacroCard(
                      label: 'Fat',
                      value: '${result.fat.toStringAsFixed(1)}g',
                      color: const Color(0xFFD62828),
                      icon: Icons.water_drop_rounded,
                    ),
                    const SizedBox(width: 10),
                    _MacroCard(
                      label: 'Fiber',
                      value: '${result.fiber.toStringAsFixed(1)}g',
                      color: const Color(0xFF52B788),
                      icon: Icons.eco_rounded,
                    ),
                  ],
                ),

                // ── Macro progress bars ───────────────────
                const SizedBox(height: 18),
                _MacroBar(
                  label: 'Protein',
                  grams: result.protein,
                  maxGrams: 60,
                  color: const Color(0xFF4A90D9),
                ),
                const SizedBox(height: 8),
                _MacroBar(
                  label: 'Carbs',
                  grams: result.carbs,
                  maxGrams: 300,
                  color: const Color(0xFFF5A623),
                ),
                const SizedBox(height: 8),
                _MacroBar(
                  label: 'Fat',
                  grams: result.fat,
                  maxGrams: 70,
                  color: const Color(0xFFD62828),
                ),

                // ── Per ingredient breakdown ──────────────
                if (result.perIngredient.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const Divider(color: AppTheme.divider),
                  const SizedBox(height: 14),
                  Row(
                    children: const [
                      Text(
                        'Per Ingredient',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...result.perIngredient.map(
                    (item) => _IngredientRow(
                      name: item['name'] ?? '',
                      calories: item['calories'] ?? 0,
                      totalCalories: result.calories,
                    ),
                  ),
                ],

                // ── Disclaimer ────────────────────────────
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFAEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: Color(0xFFF5A623),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Yeh AI ka estimate hai, exact values vary ho sakti hain.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF856404),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Re-analyze button ─────────────────────
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onReAnalyze,
                  child: Container(
                    width: double.infinity,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFF52B788),
                        width: 1.5,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Color(0xFF52B788),
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Dobara Analyze Karo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF52B788),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Sub-widgets
// ─────────────────────────────────────────────────────────────

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double grams;
  final double maxGrams;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.grams,
    required this.maxGrams,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (grams / maxGrams).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 7,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${grams.toStringAsFixed(0)}g',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String name;
  final int calories;
  final int totalCalories;

  const _IngredientRow({
    required this.name,
    required this.calories,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final pct = totalCalories > 0 ? (calories / totalCalories) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: const Color(0xFFEEEEEE),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF52B788)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$calories kcal',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
