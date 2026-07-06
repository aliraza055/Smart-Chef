import 'dart:async';

import 'package:get/get.dart';
import 'package:smart_chef/Services/favorite_service.dart';

/// Pehle is page mein StreamBuilder seedha UI ke andar tha.
/// Ab hum stream ko controller ke andar "consume" karte hain aur
/// result ek RxList mein daal dete hain. View ko stream ka pata hi
/// nahi chalta — wo sirf `controller.recipes` dekhta hai.
class FavoriteController extends GetxController {
  final FavoriteService _favoriteService = FavoriteService();

  final RxList<Map<String, dynamic>> recipes = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _favoriteService.getFavoriteRecipesStream().listen((data) {
      // assignAll RxList ka built-in method hai: purani list clear
      // karke nayi daalta hai, aur khud hi listeners ko notify karta
      // hai — manual setState/refresh() ki zaroorat nahi.
      recipes.assignAll(data);
      isLoading.value = false;
    });
  }

  Future<void> toggleFavorite(String docId) async {
    await _favoriteService.toggleFavorite(docId);
    // Stream khud hi naya data push kar dega (Firestore listener),
    // recipes list apne aap update ho jayegi — yahan kuch aur karne
    // ki zaroorat nahi.
  }

  @override
  void onClose() {
    // Stream subscription cancel karna zaroori hai warna controller
    // dispose hone ke baad bhi Firestore listener chalta rahega
    // (memory leak + unnecessary reads).
    _subscription?.cancel();
    super.onClose();
  }
}
