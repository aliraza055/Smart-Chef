import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Example: Recipe Categories List
    List<String> categories = [
      'Breakfast',
      'Lunch',
      'Dinner',
      'Snacks',
      'Desserts',
      'Beverages',
      'Fast Food',
    ];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(),
            borderRadius: BorderRadius.circular(100),
          ),

          child: Text(categories[index]),
          padding: EdgeInsets.all(10),
        );
      },
    );
  }
}
