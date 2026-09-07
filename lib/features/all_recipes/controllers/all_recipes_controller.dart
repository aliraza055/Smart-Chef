import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_chef/core/services/favorite_service.dart';

class AllRecipesController extends GetxController {
  final FavoriteService _favService = FavoriteService();
  final TextEditingController searchController = TextEditingController();

  final RxString query = ''.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxList<Map<String, dynamic>> allRecipes = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<Set<String>>? _favSub;
  StreamSubscription<QuerySnapshot>? _recipeSub;

  @override
  void onInit() {
    super.onInit();

    _favSub = _favService.favoritesStream().listen((ids) {
      favoriteIds.assignAll(ids);
    });

    _recipeSub = FirebaseFirestore.instance
        .collection('Receipes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            allRecipes.assignAll(
              snapshot.docs.map((d) {
                final map = d.data() as Map<String, dynamic>;
                return {...map, 'docId': d.id};
              }),
            );
            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
          },
        );
  }

  void updateQuery(String val) {
    query.value = val.trim().toLowerCase();
  }

  void clearQuery() {
    searchController.clear();
    query.value = '';
  }

  void toggleFavorite(String recipeId) {
    _favService.toggleFavorite(recipeId);
  }

  List<Map<String, dynamic>> get filteredRecipes {
    if (query.isEmpty) {
      return allRecipes;
    }
    final q = query.value;
    return allRecipes.where((recipe) {
      final name = (recipe['name'] ?? '').toString().toLowerCase();
      final category = (recipe['category'] ?? '').toString().toLowerCase();
      return name.contains(q) || category.contains(q);
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
