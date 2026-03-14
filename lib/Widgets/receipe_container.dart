import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String time;
  final String likes;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.time,
    required this.likes,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(color: Colors.greenAccent, width: 1.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Favorite Icon on top right
        Positioned(
          top: 10,
          right: 24,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                //color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
