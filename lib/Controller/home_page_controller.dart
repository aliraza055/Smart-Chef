import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smart_chef/Services/favorite_service.dart';

class HomePageController extends GetxController {
  final RxString selectedCategory = 'All'.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;
  final FavoriteService _favService = FavoriteService();
  StreamSubscription<Set<String>>? _favoriteSub;

  @override
  void onInit() {
    super.onInit();
    _favoriteSub = _favService.favoritesStream().listen((ids) {
      favoriteIds.value = ids;
    });
  }

  void selectCategory(String value) {
    selectedCategory.value = value;
  }

  void toggleFavorite(String recipeId) {
    _favService.toggleFavorite(recipeId);
  }

  Stream<QuerySnapshot> getRecipesStream() {
    final col = FirebaseFirestore.instance.collection('Receipes');
    if (selectedCategory.value == 'All') {
      return col.orderBy('createdAt', descending: true).snapshots();
    }
    return col
        .where('category', isEqualTo: selectedCategory.value)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  void onClose() {
    _favoriteSub?.cancel();
    super.onClose();
  }
}

