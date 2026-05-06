import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Widgets/safe_image.dart';

class ReviewsList extends StatelessWidget {
  final String recipeId;

  const ReviewsList({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // ✅ orderBy hataya — composite index ki zaroorat nahi
      stream: FirebaseFirestore.instance
          .collection('Reviews')
          .where('recipeId', isEqualTo: recipeId)
          .snapshots(),
      builder: (context, snapshot) {
        // ✅ Error log karo — debug ke liye
        if (snapshot.hasError) {
          print('ReviewsList Error: ${snapshot.error}');
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }

        final reviews = snapshot.data?.docs ?? [];

        if (reviews.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No reviews yet. Be the first to review!',
                style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${reviews.length} reviews',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Review Cards ─────────────────────────
            ...reviews.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return _ReviewCard(
                userId: data['userId'] ?? '',
                userName: data['userName'] ?? 'Anonymous',
                userPhoto: data['userPhoto'] ?? '',
                rating: (data['rating'] ?? 0).toDouble(),
                comment: data['comment'] ?? '',
                createdAt: data['createdAt'],
              );
            }),
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final String userId;
  final String userName;
  final String userPhoto;
  final double rating;
  final String comment;
  final dynamic createdAt;

  const _ReviewCard({
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  String? _fetchedPhotoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserPhoto();
  }

  Future<void> _fetchUserPhoto() async {
    if (widget.userId.isEmpty) return;
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get();
    if (doc.exists && mounted) {
      setState(() => _fetchedPhotoUrl = doc.data()?['imageUrl'] ?? '');
    }
  }

  String _timeAgo(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final date = (timestamp as Timestamp).toDate();
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = (_fetchedPhotoUrl != null && _fetchedPhotoUrl!.isNotEmpty)
        ? _fetchedPhotoUrl!
        : widget.userPhoto;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: SafeNetworkImage(
                    url: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: AppTheme.primary.withOpacity(0.1),
                      child: Center(
                        child: Text(
                          widget.userName.isNotEmpty
                              ? widget.userName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Name + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      _timeAgo(widget.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Stars
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < widget.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppTheme.starColor,
                    size: 16,
                  );
                }),
              ),
            ],
          ),

          if (widget.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              widget.comment,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMedium,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
