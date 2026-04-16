import 'package:flutter/material.dart';

/// Core color tokens for the Open Otaku design system.
/// Dark, cinematic, premium palette.
abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A0B);
  static const Color surface = Color(0xFF141416);
  static const Color surfaceElevated = Color(0xFF1C1C20);

  // Borders
  static const Color border = Color(0xFF26262B);

  // Brand
  static const Color primary = Color(0xFFFF3D2E);
  static const Color primaryGlow = Color(0xFFFF6B4A);
  static const Color accent = Color(0xFFF5B544);

  // Text
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF6B6B75);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);

  // Derived
  static const Color primaryWithOpacity40 = Color(0x66FF3D2E);
  static const Color surfaceWithOpacity60 = Color(0x99141416);
  static const Color backgroundWithOpacity0 = Color(0x000A0A0B);
  static const Color backgroundWithOpacity80 = Color(0xCC0A0A0B);
}
