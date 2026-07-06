import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Services/favorite_service.dart';

class SearchPageController extends GetxController {
  final FavoriteService _favoriteService = FavoriteService();

  final TextEditingController searchController = TextEditingController();

  final RxString query = ''.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxList<Map<String, dynamic>> allRecipes = <Map<String, dynamic>>[].obs;

  StreamSubscription<Set<String>>? _favSub;
  StreamSubscription<QuerySnapshot>? _recipeSub;

  @override
  void onInit() {
    super.onInit();

    _favSub = _favoriteService.favoritesStream().listen((ids) {
      favoriteIds.assignAll(ids);
    });

    // BUG FIX: pehle yahan Firestore ka
    // orderBy('name').startAt([_query]).endAt(['$_query\uf8ff'])
    // use ho raha tha — ye case-SENSITIVE hai. Query lowercase hoti
    // thi lekin agar Firestore mein naam "Chicken Biryani" (capital
    // C) save hai, to range kabhi match nahi karti (Firestore
    // ordering ASCII based hai: 'C' < 'c'). Category se search
    // karna bhi is approach se possible nahi tha (wo sirf name-
    // prefix match karta hai).
    //
    // Fix: poori collection realtime le lo, Dart ke andar khud
    // case-insensitive `.contains()` se filter karo (name aur
    // category dono). FYP/medium scale (hazaron recipes tak) ke
    // liye ye reliable hai. Bohot bade scale ke liye dedicated
    // search service (Algolia/Typesense) chahiye — abhi zaroorat
    // nahi.
    _recipeSub = FirebaseFirestore.instance
        .collection('Receipes')
        .snapshots()
        .listen((snapshot) {
          allRecipes.assignAll(
            snapshot.docs.map(
              (d) => {...d.data() as Map<String, dynamic>, 'docId': d.id},
            ),
          );
        });
  }

  void updateQuery(String value) {
    query.value = value.trim().toLowerCase();
  }

  void clearQuery() {
    searchController.clear();
    query.value = '';
  }

  Future<void> toggleFavorite(String docId) async {
    await _favoriteService.toggleFavorite(docId);
  }

  /// Pure function — koi Rx read/write nahi karta, sirf diya hua
  /// data filter karta hai. Case-insensitive `.contains()` name aur
  /// category dono par — isliye ab "Chicken", "chicken", ya sirf
  /// category ka naam type karne par bhi results milenge.
  static List<Map<String, dynamic>> filterRecipes(
    String query,
    List<Map<String, dynamic>> recipes,
  ) {
    if (query.isEmpty) return [];
    return recipes.where((data) {
      final name = (data['name'] ?? '').toString().toLowerCase();
      final category = (data['category'] ?? '').toString().toLowerCase();
      return name.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void onClose() {
    _favSub?.cancel();
    _recipeSub?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
