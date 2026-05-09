import 'package:flutter/material.dart';

class AppTheme {
  // ── Primary — Warm Terracotta ──────────────────────
  // Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)
  static const Color primary = Color(0xFF2D6A4F); // deep terracotta
  static const Color primaryLight = Color(0xFFE05A20); // medium orange-red
  static const Color primaryAccent = Color(0xFFFF7A45); // bright accent
  static const Color primarySoft = Color(0xFFFFF0E8); // very light tint

  // ── Backgrounds ───────────────────────────────────
  static const Color background = Color(0xFFFDF6EF); // warm cream
  static const Color surface = Color(0xFFFFFFFF); // pure white cards
  static const Color cardBg = Color(0xFFFFF8F3); // slightly warm card
  static const Color divider = Color(0xFFF0EAE3); // warm divider

  // ── Header / Dark ─────────────────────────────────
  static const Color headerBg = Color(0xFF1C1008); // deep warm black
  static const Color headerMid = Color(0xFF2D1A0A); // mid dark

  // ── Text ──────────────────────────────────────────
  static const Color textDark = Color(0xFF1C1008); // warm near-black
  static const Color textMedium = Color(0xFF6B5344); // warm brown-grey
  static const Color textLight = Color(0xFFB8A49A); // muted warm grey

  // ── Semantic ──────────────────────────────────────
  static const Color starColor = Color(0xFFF5A623); // golden amber
  static const Color success = Color(0xFF2D6A4F); // deep green
  static const Color error = Color(0xFFD62828); // red

  // ── Shadow ────────────────────────────────────────
  static const Color cardShadow = Color(0x141C1008); // 8% warm black

  // ── Text Styles ───────────────────────────────────
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

  // ── Theme ─────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(primary: primary, surface: surface),
  );
}
