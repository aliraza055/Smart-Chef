import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'All',
      'Breakfast',
      'Lunch',
      'Dinner',
      'Snacks',
      'Desserts',
      'Beverages',
      'Fast Food',
    ];

    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 5),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(),
              borderRadius: BorderRadius.circular(100),
            ),

            child: Text(
              categories[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
