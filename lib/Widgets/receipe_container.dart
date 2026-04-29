import 'package:flutter/material.dart';
import 'package:smart_chef/Constants/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String time;
  final String likes;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;
  final String? tag; // e.g. "VEGAN", "CLASSIC", "FAST"

  const RecipeCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.time,
    required this.likes,
    required this.isFavorite,
    this.onFavoriteToggle,
    this.onTap,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: const Color(0xFFF0F0F0),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite
                            ? AppTheme.primary
                            : AppTheme.textLight,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Star + rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppTheme.starColor,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        likes,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Recipe name
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tag or time
                  if (tag != null && tag!.isNotEmpty)
                    _TagChip(label: tag!)
                  else if (time.isNotEmpty)
                    Text(
                      '$time MIN',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMedium,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class RecipeCard extends StatelessWidget {
//   final String image;
//   final String name;
//   final String description;
//   final String time;
//   final String likes;
//   final bool isFavorite;
//   final VoidCallback onFavoriteToggle;

//   const RecipeCard({
//     super.key,
//     required this.image,
//     required this.name,
//     required this.description,
//     required this.time,
//     required this.likes,
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(bottom: 10),
//           margin: const EdgeInsets.only(bottom: 15),
//           decoration: BoxDecoration(
//             color: Colors.white10,
//             border: Border.all(color: Colors.greenAccent, width: 1.5),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//                 child: Image.network(
//                   image,
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       description,
//                       style: TextStyle(color: Colors.grey[700], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         Positioned(
//           //   top: 6,
//           right: 2,
//           child: GestureDetector(
//             onTap: onFavoriteToggle,
//             child: Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: isFavorite ? Colors.red : Colors.black,
//                 size: 28,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
