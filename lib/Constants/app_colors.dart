import 'package:flutter/material.dart';

// class AppColors {
//   static const primary = Color(0xFFB03A10);
//   static const secoundry = Color(0xFFF5F3F0);
//   static const background = Color(0xFFF5F3F0);
//   static const textDark = Colors.black;
// }
class AppTheme {
  // Colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C5A);
  static const Color background = Color(0xFFFDF6EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFB0B0B0);
  static const Color starColor = Color(0xFFFFB800);
  static const Color cardShadow = Color(0x14000000);

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textDark,
    letterSpacing: -0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textDark,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textMedium,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textMedium,
    letterSpacing: 0.5,
  );

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(primary: primary, surface: surface),
    fontFamily: 'Poppins',
  );
}
