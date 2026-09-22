import 'package:flutter/material.dart';

abstract final class AppColors {
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
}
