import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  final Function(String) onCategorySelected;
  const CategoryTile({super.key, required this.onCategorySelected});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  int selectedIndex = 0;
  final List<String> categories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Biryani',
    'Fast Food',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onCategorySelected(categories[index]);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected == index
                    ? Colors.green
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
