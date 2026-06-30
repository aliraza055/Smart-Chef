// lib/Constants/app_colors.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Brand color stays constant across themes
  static const Color primary = Color(0xFF2D6A4F);

  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color lightSurface = Colors.white;
  static const Color lightTextDark = Color(0xFF1A1A1A);
  static const Color lightTextMedium = Color(0xFF6B6B6B);
  static const Color lightTextLight = Color(0xFFADADAD);
  static const Color lightCardShadow = Color(0x14000000);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextDark = Color(0xFFF2F2F2);
  static const Color darkTextMedium = Color(0xFFB0B0B0);
  static const Color darkTextLight = Color(0xFF7A7A7A);
  static const Color darkCardShadow = Color(0x33000000);

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkBackground
      : lightBackground;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkSurface
      : lightSurface;

  static Color textDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkTextDark
      : lightTextDark;

  static Color textMedium(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkTextMedium
      : lightTextMedium;

  static Color textLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkTextLight
      : lightTextLight;

  static Color cardShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkCardShadow
      : lightCardShadow;

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
