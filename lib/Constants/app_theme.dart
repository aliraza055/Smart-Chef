// lib/Constants/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand / Accent (theme-independent) ─────────────────
  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFFE05A20);
  static const Color primaryAccent = Color(0xFFFF7A45);

  static const Color starColor = Color(0xFFF5A623);
  static const Color success = Color(0xFF2D6A4F);
  static const Color error = Color(0xFFD62828);

  // Dark gradient header (jaise pehle FoodAnalyzer header mein use hua tha) —
  // ye already dark hai, dono themes mein same rehta hai
  static const Color headerBg = Color(0xFF1C1008);
  static const Color headerMid = Color(0xFF2D1A0A);

  // ── Light theme colors ──────────────────────────────────
  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color lightSurface = Colors.white;
  static const Color lightCardBg = Color(0xFFFFF8F3);
  static const Color lightPrimarySoft = Color(0xFFFFF0E8);
  static const Color lightDivider = Color(0xFFF0EAE3);
  static const Color lightTextDark = Color(0xFF1A1A1A);
  static const Color lightTextMedium = Color(0xFF6B6B6B);
  static const Color lightTextLight = Color(0xFFADADAD);
  static const Color lightCardShadow = Color(0x14000000);

  // ── Dark theme colors ────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardBg = Color(0xFF262626);
  static const Color darkPrimarySoft = Color(0xFF2A3B32);
  static const Color darkDivider = Color(0xFF2E2E2E);
  static const Color darkTextDark = Color(0xFFF2F2F2);
  static const Color darkTextMedium = Color(0xFFB0B0B0);
  static const Color darkTextLight = Color(0xFF7A7A7A);
  static const Color darkCardShadow = Color(0x33000000);

  // ── Default colors for const contexts (uses light theme as default) ──
  static const Color background = lightBackground;
  static const Color surface = lightSurface;
  static const Color cardBg = lightCardBg;
  static const Color primarySoft = lightPrimarySoft;
  static const Color divider = lightDivider;
  static const Color textDark = lightTextDark;
  static const Color textMedium = lightTextMedium;
  static const Color textLight = lightTextLight;
  static const Color cardShadow = lightCardShadow;

  // ── Context-aware getters ────────────────────────────────
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkBackground
      : lightBackground;

  static Color getSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkSurface
      : lightSurface;

  static Color getCardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkCardBg
      : lightCardBg;

  static Color getPrimarySoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkPrimarySoft
      : lightPrimarySoft;

  static Color getDivider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkDivider
      : lightDivider;

  static Color getTextDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkTextDark
      : lightTextDark;

  static Color getTextMedium(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkTextMedium
      : lightTextMedium;

  static Color getTextLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkTextLight
      : lightTextLight;

  static Color getCardShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkCardShadow
      : lightCardShadow;

  // ── Context-aware text styles ────────────────────────────
  static TextStyle headingLarge(BuildContext context) => TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: getTextDark(context),
    letterSpacing: -0.5,
  );

  static TextStyle headingMedium(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: getTextDark(context),
    letterSpacing: -0.3,
  );

  static TextStyle headingSmall(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: getTextDark(context),
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: getTextMedium(context),
  );

  static TextStyle labelSmall(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: getTextMedium(context),
    letterSpacing: 0.5,
  );

  // ── ThemeData ─────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? primary : Colors.grey,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightTextDark,
      elevation: 0,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? primary : Colors.grey,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkTextDark,
      elevation: 0,
    ),
  );
}

