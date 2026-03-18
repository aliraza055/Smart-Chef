import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Receipes')
            .where('isFav', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }
          final recipes = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final data = recipes[index].data();
              return RecipeCard(
                image: data['image'],
                name: data['name'],
                description: data['description'],
                time: data['time'].toString(),
                likes: data['likes'].toString(),
                isFavorite: true,

                onFavoriteToggle: () {
                  FirebaseFirestore.instance
                      .collection('Receipes')
                      .doc(recipes[index].id)
                      .update({'isFav': false});
                },
              );
            },
          );
        },
      ),
    );
  }
}
