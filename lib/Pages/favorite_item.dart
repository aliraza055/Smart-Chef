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

      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
