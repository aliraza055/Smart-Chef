import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Services/ai_services.dart';

// ─────────────────────────────────────────────────────────────
//  AI Recipe Generator Page
//  Flow:
//    1. User chips mein ingredients add karta hai
//    2. "Generate" tap karta hai → Claude API call
//    3. Result card show hota hai
//    4. "Use This Recipe" → AddReceipe page pre-filled data ke saath
// ─────────────────────────────────────────────────────────────

class AiRecipeGeneratorPage extends StatefulWidget {
  const AiRecipeGeneratorPage({super.key});

  @override
  State<AiRecipeGeneratorPage> createState() => _AiRecipeGeneratorPageState();
}

class _AiRecipeGeneratorPageState extends State<AiRecipeGeneratorPage>
    with TickerProviderStateMixin {
  final _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  bool _isLoading = false;
  AiRecipeResult? _result;
  String? _errorMessage;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _resultAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _pulseController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  // ── Add ingredient chip ───────────────────────────────────
  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isEmpty) return;
    if (_ingredients.contains(text)) {
      _ingredientController.clear();
      return;
    }
    setState(() {
      _ingredients.add(text);
      _ingredientController.clear();
      _result = null;
      _errorMessage = null;
    });
  }

  // ── Remove ingredient chip ────────────────────────────────
  void _removeIngredient(String item) {
    setState(() {
      _ingredients.remove(item);
      _result = null;
    });
  }

  // ── Call AI ───────────────────────────────────────────────
  Future<void> _generate() async {
    if (_ingredients.isEmpty) {
      setState(() => _errorMessage = 'Enter atleaset one gredient!');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await AiService().generateRecipe(_ingredients);
      setState(() {
        _result = result;
        _isLoading = false;
      });
      _resultController.forward(from: 0);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // ── Navigate to AddReceipe with pre-filled data ───────────
  void _useThisRecipe() {
    if (_result == null) return;
    Navigator.pop(context, _result); // AddReceipe page handle karega
  }

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ───────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader()),

          // ── Ingredient Input ─────────────────────────────
          SliverToBoxAdapter(child: _buildIngredientInput()),

          // ── Chips ────────────────────────────────────────
          if (_ingredients.isNotEmpty) SliverToBoxAdapter(child: _buildChips()),

          // ── Generate Button ──────────────────────────────
          SliverToBoxAdapter(child: _buildGenerateButton()),

          // ── Error ────────────────────────────────────────
          if (_errorMessage != null) SliverToBoxAdapter(child: _buildError()),

          // ── Loading Animation ─────────────────────────────
          if (_isLoading) SliverToBoxAdapter(child: _buildLoadingCard()),

          // ── Result Card ───────────────────────────────────
          if (_result != null && !_isLoading)
            SliverToBoxAdapter(child: _buildResultCard()),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  WIDGETS
  // ─────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
      decoration: const BoxDecoration(
        color: AppTheme.headerBg,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // AI sparkle badge
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
            'Recipe Generator',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tell the ingridients of your home,\nAI will create receipe!',
            style: TextStyle(fontSize: 14, color: Colors.white60, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ENTER YOUR INGREDIENTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.cardShadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _ingredientController,
                    onSubmitted: (_) => _addIngredient(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'e.g. chicken, tomatoes, garlic...',
                      hintStyle: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.kitchen_outlined,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _addIngredient,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'After enters ingridients "+" Press Enter',
            style: TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_ingredients.length} ingredient${_ingredients.length > 1 ? 's' : ''} added',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ingredients
                .map(
                  (item) => _IngredientChip(
                    label: item,
                    onDelete: () => _removeIngredient(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: ScaleTransition(
        scale: _ingredients.isEmpty
            ? const AlwaysStoppedAnimation(1.0)
            : _pulseAnimation,
        child: GestureDetector(
          onTap: _isLoading ? null : _generate,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: _ingredients.isEmpty
                  ? const LinearGradient(
                      colors: [Color(0xFFCCCCCC), Color(0xFFBBBBBB)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: _ingredients.isEmpty
                  ? []
                  : [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  _isLoading
                      ? 'AI Is Creating receipe...'
                      : 'Create Receipe with AI ',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFCDD2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 13, color: AppTheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: AppTheme.cardShadow, blurRadius: 16),
          ],
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: AppTheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'AI Chef is making receipe...',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _ingredients.join(' • '),
              style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final r = _result!;
    return FadeTransition(
      opacity: _resultAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(_resultAnimation),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.cardShadow,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top banner ──────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.headerBg,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFF5A623),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'AI GENERATED RECIPE',
                            style: TextStyle(
                              color: Color(0xFFF5A623),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          _DifficultyBadge(difficulty: r.difficulty),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        r.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        r.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Meta row ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      _MetaChip(
                        icon: Icons.access_time_rounded,
                        label: '${r.time.toInt()} min',
                      ),
                      const SizedBox(width: 10),
                      _MetaChip(icon: Icons.restaurant_menu, label: r.category),
                      const SizedBox(width: 10),
                      _MetaChip(
                        icon: Icons.kitchen_outlined,
                        label: '${r.ingredients.length} items',
                      ),
                    ],
                  ),
                ),

                // ── Ingredients ─────────────────────────
                _SectionTitle(
                  title: 'Ingredients',
                  count: r.ingredients.length,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: r.ingredients
                        .asMap()
                        .entries
                        .map(
                          (e) => _ListItem(
                            index: e.key + 1,
                            text: e.value,
                            isStep: false,
                          ),
                        )
                        .toList(),
                  ),
                ),

                // ── Steps ────────────────────────────────
                _SectionTitle(title: 'Steps', count: r.steps.length),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: r.steps
                        .asMap()
                        .entries
                        .map(
                          (e) => _ListItem(
                            index: e.key + 1,
                            text: e.value,
                            isStep: true,
                          ),
                        )
                        .toList(),
                  ),
                ),

                // ── Action buttons ────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Use Recipe button
                      GestureDetector(
                        onTap: _useThisRecipe,
                        child: Container(
                          width: double.infinity,
                          height: 54,
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Use this Receipe',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Try again button
                      GestureDetector(
                        onTap: _generate,
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppTheme.primary,
                              width: 1.8,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: AppTheme.primary,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Regenrate Receipe',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
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
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Helper Widgets
// ─────────────────────────────────────────────────────────────

class _IngredientChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const _IngredientChip({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = difficulty == 'easy'
        ? const Color(0xFF2D6A4F)
        : difficulty == 'medium'
        ? const Color(0xFFF5A623)
        : const Color(0xFFD62828);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;

  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final int index;
  final String text;
  final bool isStep;

  const _ListItem({
    required this.index,
    required this.text,
    required this.isStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isStep
                  ? AppTheme.primary
                  : AppTheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isStep ? Colors.white : AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMedium,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
