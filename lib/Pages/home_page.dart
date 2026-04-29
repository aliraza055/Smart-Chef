import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Widgets/home_header.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';
import 'package:smart_chef/Widgets/search_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _selectedCategory = 'All';
  int _navIndex = 0;

  Stream<QuerySnapshot> _getRecipesStream() {
    final col = FirebaseFirestore.instance.collection('Receipes');
    if (_selectedCategory == 'All') return col.snapshots();
    return col.where('category', isEqualTo: _selectedCategory).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Header ───────────────────────────────────────────
          const SliverToBoxAdapter(child: HomeHeader()),

          // ─── Search Bar ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SmartSearchBar(
                onChanged: (val) {
                  // Hook up search logic here
                },
              ),
            ),
          ),

          // ─── Categories ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Categories', style: AppTheme.headingMedium),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CategoryRow(
                    onCategorySelected: (val) {
                      setState(() => _selectedCategory = val);
                    },
                  ),
                ],
              ),
            ),
          ),

          // ─── "Popular Today" label ────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 16),
              child: Text('Popular Today', style: AppTheme.headingMedium),
            ),
          ),

          // ─── Recipe Grid ──────────────────────────────────────
          StreamBuilder<QuerySnapshot>(
            stream: _getRecipesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No recipes found!',
                      style: AppTheme.bodyMedium,
                    ),
                  ),
                );
              }

              final recipes = snapshot.data!.docs;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = recipes[index].data() as Map<String, dynamic>;
                    final isFav = data['isFav'] is bool
                        ? data['isFav'] as bool
                        : data['isFav'] == 'true';

                    return RecipeCard(
                      image: data['image'] ?? '',
                      name: data['name'] ?? '',
                      description: data['description'] ?? '',
                      time: data['time']?.toString() ?? '',
                      likes: data['likes']?.toString() ?? '0',
                      isFavorite: isFav,
                      tag: data['tag'] ?? '',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageRouter.detailPage,
                          arguments: data,
                        );
                      },
                      onFavoriteToggle: () {
                        FirebaseFirestore.instance
                            .collection('Receipes')
                            .doc(recipes[index].id)
                            .update({'isFav': !isFav});
                      },
                    );
                  }, childCount: recipes.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_chef/Pages/deital_page.dart';
// import 'package:smart_chef/Routers/page_router.dart';
// import 'package:smart_chef/Widgets/category_tile.dart';
// import 'package:smart_chef/Widgets/receipe_container.dart';
// import 'package:smart_chef/Widgets/upper_contanier.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   String selectedCategory = 'All';

//   Stream<QuerySnapshot> _getRecipesStream() {
//     if (selectedCategory == 'All') {
//       return FirebaseFirestore.instance.collection('Receipes').snapshots();
//     } else {
//       return FirebaseFirestore.instance
//           .collection('Receipes')
//           .where('category', isEqualTo: selectedCategory)
//           .snapshots();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             UpperContanier(),
//             const SizedBox(height: 10),

//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Categories',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 10),

//                   CategoryTile(
//                     onCategorySelected: (value) {
//                       setState(() {
//                         selectedCategory = value;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   StreamBuilder<QuerySnapshot>(
//                     stream: _getRecipesStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text('No recipes found!'));
//                       }

//                       final recipes = snapshot.data!.docs;

//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: recipes.length,
//                         itemBuilder: (context, index) {
//                           final data = recipes[index].data() as Map;
//                           final isFav = (data['isFav'] is bool)
//                               ? data['isFav']
//                               : data['isFav'] == 'true';

//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 PageRouter.detailPage,
//                                 arguments: data,
//                               );
//                             },

//                             child: RecipeCard(
//                               image: data['image'],
//                               name: data['name'],
//                               description: data['description'],
//                               time: data['time'].toString(),
//                               likes: data['likes'].toString(),
//                               isFavorite: isFav ?? true,

//                               onFavoriteToggle: () {
//                                 FirebaseFirestore.instance
//                                     .collection('Receipes')
//                                     .doc(recipes[index].id)
//                                     .update({'isFav': !isFav});
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
