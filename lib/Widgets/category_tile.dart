import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

class CategoryItem {
  final String label;
  final String emoji;
  final Color bgColor;

  const CategoryItem({
    required this.label,
    required this.emoji,
    required this.bgColor,
  });
}

// Default category list — customize as needed
const List<CategoryItem> defaultCategories = [
  CategoryItem(label: 'All', emoji: '🍽️', bgColor: Color(0xFFFFE5D9)),
  CategoryItem(label: 'Breakfast', emoji: '🍞', bgColor: Color(0xFFFFE5D9)),
  CategoryItem(label: 'Lunch', emoji: '🍔', bgColor: Color(0xFFD4F5E2)),
  CategoryItem(label: 'Dinner', emoji: '🍛', bgColor: Color(0xFFFFF3CD)),
  CategoryItem(label: 'Dessert', emoji: '🍦', bgColor: Color(0xFFE8E8E8)),
  CategoryItem(label: 'Drinks', emoji: '🥤', bgColor: Color(0xFFD9EDFF)),
];

class CategoryChip extends StatelessWidget {
  final CategoryItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : item.bgColor,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryRow extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;
  final List<CategoryItem> categories;

  const CategoryRow({
    super.key,
    required this.onCategorySelected,
    this.categories = defaultCategories,
  });

  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: widget.categories.map((cat) {
          return CategoryChip(
            item: cat,
            isSelected: _selected == cat.label,
            onTap: () {
              setState(() => _selected = cat.label);
              widget.onCategorySelected(cat.label);
            },
          );
        }).toList(),
      ),
    );
  }
}
