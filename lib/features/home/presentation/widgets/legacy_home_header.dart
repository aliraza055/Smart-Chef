// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_chef/core/constants/app_theme.dart';

// class HomeHeader extends StatelessWidget {
//   const HomeHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Container(
//       padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
//       color: Colors.amberAccent,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Logo
//           Row(
//             children: [
//               Icon(Icons.search_rounded, color: AppTheme.primary, size: 26),
//               const SizedBox(width: 6),
//               const Text(
//                 'Smart Chef',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   color: AppTheme.primary,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),

//           // Avatar
//           GestureDetector(
//             onTap: () {
//               // Navigate to profile
//             },
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: AppTheme.primary, width: 2),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppTheme.primary.withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: (user?.photoURL != null)
//                     ? Image.network(user!.photoURL!, fit: BoxFit.cover)
//                     : const Icon(
//                         Icons.person_rounded,
//                         color: AppTheme.primary,
//                         size: 26,
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

