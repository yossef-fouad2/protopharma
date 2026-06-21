import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Colors
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color secondaryIndigo = Color(0xFF6366F1);

  // Surface Colors
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Colors.white;
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  
  // Neutral Colors (Slate palette)
  static const Color textHeadline = Color(0xFF0F172A);
  static const Color textBody = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}
