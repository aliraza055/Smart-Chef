import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Pages/deital_page.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';
import 'package:smart_chef/Widgets/upper_contanier.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> favoriteRecipes = [];
  String selectedCategory = 'All';

  Stream<QuerySnapshot> _getRecipesStream() {
    if (selectedCategory == 'All') {
      return FirebaseFirestore.instance.collection('Receipes').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Receipes')
          .where('category', isEqualTo: selectedCategory)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            UpperContanier(),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  CategoryTile(
                    onCategorySelected: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  StreamBuilder(
                    stream: _getRecipesStream(),
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
                          final data =
                              recipes[index].data() as Map<String, dynamic>;
                          bool isFev = favoriteRecipes.contains(data);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DeitalPage(receipe: data),
                                ),
                              );
                            },
                            child: RecipeCard(
                              image: data['image'],
                              name: data['name'],
                              description: data['description'],
                              time: data['time'].toString(),
                              likes: data['likes'].toString(),
                              isFavorite: isFev,
                              onFavoriteToggle: () {
                                setState(() {
                                  if (isFev) {
                                    favoriteRecipes.remove(data);
                                  } else {
                                    favoriteRecipes.add(data);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
