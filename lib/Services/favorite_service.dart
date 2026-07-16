import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final _db = FirebaseFirestore.instance;
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  Stream<Set<String>> favoritesStream() {
    if (_uid == null) return Stream.value({});
    return _db.collection('Users').doc(_uid).snapshots().map((doc) {
      final ids = List<String>.from(doc.data()?['favoriteRecipeIds'] ?? []);
      return ids.toSet();
    });
  }

  Future<void> toggleFavorite(String recipeId) async {
    if (_uid == null) return;
    final userRef = _db.collection('Users').doc(_uid);
    final doc = await userRef.get();
    final ids = List<String>.from(doc.data()?['favoriteRecipeIds'] ?? []);

    if (ids.contains(recipeId)) {
      ids.remove(recipeId);
    } else {
      ids.add(recipeId);
    }

    await userRef.update({
      'favoriteRecipeIds': ids,
      'totalFavorites': ids.length,
    });
  }

  Stream<List<Map<String, dynamic>>> getFavoriteRecipesStream() async* {
    if (_uid == null) {
      yield [];
      return;
    }
    await for (final userSnap
        in _db.collection('Users').doc(_uid).snapshots()) {
      final ids = List<String>.from(
        userSnap.data()?['favoriteRecipeIds'] ?? [],
      );
      if (ids.isEmpty) {
        yield [];
        continue;
      }
      final recipeSnap = await _db
          .collection('Receipes')
          .where(FieldPath.documentId, whereIn: ids)
          .get();
      yield recipeSnap.docs.map((d) => {...d.data(), 'docId': d.id}).toList();
    }
  }
}

