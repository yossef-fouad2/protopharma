import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // Headlines (Outfit)
  static TextStyle get h1 => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeadline,
  );

  static TextStyle get h2 => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textHeadline,
  );

  // UI Labels & Titles (Cairo - as established in the design system)
  static TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textHeadline,
  );

  // Body & Data (Inter)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
  );

  static TextStyle get tableCell => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
  );

  // Backward compatibility getters for existing screens
  static TextStyle get cairoBold => GoogleFonts.cairo(
    fontWeight: FontWeight.w700,
  );

  static TextStyle get outfitMedium => GoogleFonts.outfit(
    fontWeight: FontWeight.w500,
  );

  static TextStyle get poppinsMedium => GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
  );
}
