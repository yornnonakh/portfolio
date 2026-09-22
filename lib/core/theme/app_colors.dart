import 'package:flutter/material.dart';

abstract final class AppColors {
  // Dark colors
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF1C1C1E);
  static const primary = Color(0xFF0A84FF);
  static const blue = Color(0xFF64D2FF);
  static const purple = Color(0xFFBF5AF2);
  static const coral = Color(0xFFFF9F0A);
  static const sky = Color(0xFF5AC8FA);
  static const ink = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFFF5F5F7);
  static const textSecondary = Color(0xFFAEAEB2);
  static const textMuted = Color(0xFF8E8E93);
  static const glassBorder = Color(0x24FFFFFF);

  // Light colors
  static const backgroundLight = Color(0xFFF2F2F7);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const primaryLight = Color(0xFF007AFF);
  static const textPrimaryLight = Color(0xFF1C1C1E);
  static const textSecondaryLight = Color(0xFF545458);
  static const textMutedLight = Color(0xFF8E8E93);
  static const glassBorderLight = Color(0x1A000000);

  // Helper getters depending on Brightness
  static Color backgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? background : backgroundLight;

  static Color surfaceFor(Brightness brightness) =>
      brightness == Brightness.dark ? surface : surfaceLight;

  static Color primaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? primary : primaryLight;

  static Color textPrimaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? textPrimary : textPrimaryLight;

  static Color textSecondaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? textSecondary : textSecondaryLight;

  static Color glassBorderFor(Brightness brightness) =>
      brightness == Brightness.dark ? glassBorder : glassBorderLight;

  // Ultra-light accent palette for timeline & smooth highlights
  static Color ultraLightAccent(int index, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (index % 4) {
      0 => isDark ? const Color(0xFF64C8FF) : const Color(0xFF007AFF),
      1 => isDark ? const Color(0xFF9D94FF) : const Color(0xFF5856D6),
      2 => isDark ? const Color(0xFF5DE0E6) : const Color(0xFF00A8A8),
      _ => isDark ? const Color(0xFFFFB366) : const Color(0xFFD97000),
    };
  }
}

abstract final class AppGradients {
  static const primary = LinearGradient(
    colors: [Color(0xFF0A84FF), Color(0xFF007AFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const mint = LinearGradient(
    colors: [Color(0xFF64D2FF), Color(0xFF0A84FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const violet = LinearGradient(
    colors: [Color(0xFFBF5AF2), Color(0xFF5E5CE6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glass = LinearGradient(
    colors: [Color(0xF21C1C1E), Color(0xE8171719)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassLight = LinearGradient(
    colors: [Color(0xF8FFFFFF), Color(0xECF0F3F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient glassFor(Brightness brightness) =>
      brightness == Brightness.dark ? glass : glassLight;
}
