import 'package:flutter/material.dart';
import 'package:smart_chef/core/constants/app_theme.dart';

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
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.getSurface(context),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.getDivider(context),
            width: .5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : AppTheme.getTextMedium(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final List<CategoryItem> categories;

  const CategoryRow({
    super.key,
    this.selectedCategory = 'All',
    required this.onCategorySelected,
    this.categories = defaultCategories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected =
              selectedCategory.toLowerCase() == cat.label.toLowerCase();
          return CategoryChip(
            item: cat,
            isSelected: isSelected,
            onTap: () {
              onCategorySelected(cat.label);
            },
          );
        }).toList(),
      ),
    );
  }
}
