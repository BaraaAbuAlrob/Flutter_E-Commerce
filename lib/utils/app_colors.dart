import 'package:flutter/material.dart';

class AppColors {
  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.grey;
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color yellow = Colors.yellow;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black12 = Colors.black12;
  static const Color black45 = Colors.black45;
  static const Color blue = Colors.blue;
  static const Color primary = Color(0xFF03A9F4);

  // Auth Colors
  static const Color authPrimary = Color(0xFF5046E5);
  static const Color authPrimaryDark = Color(0xFF4338CA);
  static const Color authPrimaryLight = Color(0xFFEEF2FF);
  static const Color authInputBg = Color(0xFFF9FAFB);
  static const Color authInputBorder = Color(0xFFF0F1F3);
  static const Color authTextDark = Color(0xFF1F222A);
  static const Color authTextSecondary = Color(0xFF8F959E);
  static const Color authSuccess = Color(0xFF10B981);
  static const Color authLink = Color(0xFF5046E5);

  // Shadow Colors
  static final Color shadowSubtle = Colors.black.withValues(alpha: 0.03);
  static final Color shadowMedium = Colors.black.withValues(alpha: 0.08);
  static final Color shadowStrong = Colors.black.withValues(alpha: 0.12);

  // Dynamic Opacity Helpers
  static Color blackWithOpacity(double opacity) =>
      Colors.black.withValues(alpha: opacity);
  static Color whiteWithOpacity(double opacity) =>
      Colors.white.withValues(alpha: opacity);
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);

  static Color? getColorByName(String name) {
    switch (name) {
      case 'black':
        return black;
      case 'white':
        return white;
      case 'red':
        return red;
      case 'blue':
        return blue;
      case 'green':
        return green;
      case 'yellow':
        return yellow;
      default:
        return null;
    }
  }
}
