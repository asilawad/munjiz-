import 'package:flutter/material.dart';

/// Central color palette of Munjiz: blue + cyan brand, yellow achievement accent.
/// Every color used in the UI must be defined here.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF0B5FFF);
  static const Color primaryDark = Color(0xFF0842B8);
  static const Color cyan = Color(0xFF00C2FF);
  static const Color accent = Color(0xFFFFD44D);
  static const Color accentDark = Color(0xFFF5A700);
  static const Color onAccent = Color(0xFF5A4300);

  // Surfaces
  static const Color background = Color(0xFFF4F8FF);
  static const Color backgroundEnd = Color(0xFFE8F1FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFF1F7FF);
  static const Color border = Color(0xFFDCE6F7);
  static const Color shadow = Color(0x1A0B5FFF);
  static const Color transparent = Colors.transparent;

  // Text
  static const Color textPrimary = Color(0xFF10244F);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color textHint = Color(0xFF9AA8C4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryMuted = Color(0xB3FFFFFF);

  // Status
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerSoft = Color(0xFFFEECEC);
  static const Color success = Color(0xFF22C55E);
  static const Color successSoft = Color(0xFFDDF5E8);

  // Categories
  static const Color categoryImportant = Color(0xFFF5A700);
  static const Color categoryImportantSoft = Color(0xFFFFF4D0);
  static const Color categoryPersonal = Color(0xFF0B5FFF);
  static const Color categoryPersonalSoft = Color(0xFFE3EEFF);
  static const Color categoryWork = Color(0xFF22A06B);
  static const Color categoryWorkSoft = Color(0xFFDDF5E8);
  static const Color categoryIdeas = Color(0xFF8B5CF6);
  static const Color categoryIdeasSoft = Color(0xFFEEE8FF);
  static const Color categoryOther = Color(0xFF64748B);
  static const Color categoryOtherSoft = Color(0xFFE8EDF5);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[background, backgroundEnd],
  );

  // Celebration
  static const List<Color> confetti = <Color>[
    primary,
    cyan,
    accent,
    success,
    danger,
  ];
}
