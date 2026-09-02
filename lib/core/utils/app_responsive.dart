import 'package:flutter/material.dart';

class AppResponsive {
  static const double _designWidth = 390;
  static const double _designHeight = 844;

  static double width(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return (size / _designWidth) * screenWidth;
  }

  static double height(BuildContext context, double size) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return (size / _designHeight) * screenHeight;
  }

  static double text(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = screenWidth / _designWidth;
    return size * scale;
  }

  static double radius(BuildContext context, double size) =>
      width(context, size);

  static double horizontalPadding(BuildContext context, {double size = 20}) {
    return width(context, size);
  }

  static double verticalPadding(BuildContext context, {double size = 20}) {
    return height(context, size);
  }
}

