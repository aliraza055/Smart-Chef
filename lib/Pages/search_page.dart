import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';
import 'package:smart_chef/Routers/page_router.dart';
import 'package:smart_chef/Services/favorite_service.dart';
import 'package:smart_chef/Widgets/favorite_card.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _favService = FavoriteService();
  Set<String> _favoriteIds = {};
  String _query = '';

  @override
  void initState() {
    super.initState();

    _favService.favoritesStream().listen((ids) {
      if (mounted) {
        setState(() => _favoriteIds = ids);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 🔍 Firestore Search Stream
  Stream<QuerySnapshot> _searchStream() {
    if (_query.isEmpty) {
      // ❌ empty query → kuch bhi fetch mat karo
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('Receipes')
        .orderBy('name')
        .startAt([_query])
        .endAt(['$_query\uf8ff'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 🔍 Search Field
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search recipes...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppTheme.textLight,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _query = value.trim().toLowerCase();
                        });
                      },
                    ),
                  ),
                ),

                if (_query.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Results ─────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _searchStream(),
              builder: (context, snapshot) {
                // ✅ search empty → initial empty UI
                if (_query.isEmpty) {
                  return const _EmptySearch(query: '');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _EmptySearch(query: _query);
                }

                final docs = snapshot.data!.docs;

                // client side accuracy filter
                final filtered = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final category = (data['category'] ?? '')
                      .toString()
                      .toLowerCase();

                  return name.contains(_query) || category.contains(_query);
                }).toList();

                if (filtered.isEmpty) {
                  return _EmptySearch(query: _query);
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final docId = doc.id;

                    return FavoriteCard(
                      image: data['image'] ?? '',
                      name: data['name'] ?? '',
                      description: data['description'] ?? '',
                      time: data['time']?.toString() ?? '',
                      likes: data['avgRating']?.toString() ?? '0',
                      tag: data['category'] ?? '',
                      isFavorite: _favoriteIds.contains(docId),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageRouter.detailPage,
                          arguments: {...data, 'docId': docId},
                        );
                      },
                      onFavoriteToggle: () {
                        _favService.toggleFavorite(docId);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────
class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 38,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'Search recipes...' : 'No results for "$query"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different name or category',
            style: TextStyle(fontSize: 13, color: AppTheme.textMedium),
          ),
        ],
      ),
    );
  }
}
