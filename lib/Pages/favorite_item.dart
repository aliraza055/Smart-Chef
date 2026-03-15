import 'package:flutter/material.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecipes;

  const FavoritePage({super.key, required this.favoriteRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),

      body: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final data = favoriteRecipes[index];

          return RecipeCard(
            image: data['image'],
            name: data['name'],
            description: data['description'],
            time: data['time'].toString(),
            likes: data['likes'].toString(),
            isFavorite: true,
            onFavoriteToggle: () {},
          );
        },
      ),
    );
  }
}
