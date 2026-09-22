import 'package:flutter/material.dart';

class OnboardingItem {
  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final String? imagePath;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    this.imagePath,
  });
}
