import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_chef/Models/review_receipesModel.dart';

class ReviewService {
  final _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  // ── Add or update review ──────────────────────────
  Future<void> submitReview({
    required String recipeId,
    required double rating,
    required String comment,
  }) async {
    if (_user == null) return;

    // Check if user already reviewed
    final existing = await _db
        .collection('Reviews')
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: _user!.uid)
        .get();

    final review = ReviewModel(
      recipeId: recipeId,
      userId: _user!.uid,
      userName: _user!.displayName ?? 'Anonymous',
      userPhoto: _user!.photoURL,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    if (existing.docs.isNotEmpty) {
      // Update existing review
      await _db
          .collection('Reviews')
          .doc(existing.docs.first.id)
          .update(review.toMap());
    } else {
      // Add new review
      await _db.collection('Reviews').add(review.toMap());
    }

    // Recalculate avgRating on the recipe
    await _updateRecipeRating(recipeId);
  }

  // ── Recalculate and update avgRating on recipe ────
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

  // ── Get all reviews for a recipe ──────────────────
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

  // ── Check if current user already reviewed ────────
  Future<ReviewModel?> getUserReview(String recipeId) async {
    if (_user == null) return null;
    final snap = await _db
        .collection('Reviews')
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: _user!.uid)
        .get();
    if (snap.docs.isEmpty) return null;
    return ReviewModel.fromMap(snap.docs.first.data(), snap.docs.first.id);
  }
}
