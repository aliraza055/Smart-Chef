import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_chef/features/recipe_detail/models/review_model.dart';

class ReviewService {
  final _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> submitReview({
    required String recipeId,
    required double rating,
    required String comment,
  }) async {
    if (_user == null) return;

    final existing = await _db
        .collection('Reviews')
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: _user.uid)
        .get();

    final review = ReviewModel(
      recipeId: recipeId,
      userId: _user.uid,
      userName: _user.displayName ?? 'Anonymous',
      userPhoto: _user.photoURL,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    if (existing.docs.isNotEmpty) {
      await _db
          .collection('Reviews')
          .doc(existing.docs.first.id)
          .update(review.toMap());
    } else {
      await _db.collection('Reviews').add(review.toMap());
    }

    await _updateRecipeRating(recipeId);
  }

  Future<void> _updateRecipeRating(String recipeId) async {
    final reviews = await _db
        .collection('Reviews')
        .where('recipeId', isEqualTo: recipeId)
        .get();

    if (reviews.docs.isEmpty) return;

    final total = reviews.docs
        .map((d) => (d.data()['rating'] ?? 0).toDouble())
        .reduce((a, b) => a + b);

    final avg = total / reviews.docs.length;

    await _db.collection('Receipes').doc(recipeId).update({
      'avgRating': double.parse(avg.toStringAsFixed(1)),
      'totalReviews': reviews.docs.length,
    });
  }

  Stream<List<ReviewModel>> getReviews(String recipeId) {
    return _db
        .collection('Reviews')
        .where('recipeId', isEqualTo: recipeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ReviewModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<ReviewModel?> getUserReview(String recipeId) async {
    if (_user == null) return null;
    final snap = await _db
        .collection('Reviews')
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: _user.uid)
        .get();
    if (snap.docs.isEmpty) return null;
    return ReviewModel.fromMap(snap.docs.first.data(), snap.docs.first.id);
  }
}

