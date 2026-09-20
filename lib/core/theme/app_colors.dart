import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0A0D19);
  static const surface = Color(0xFF1B2032);
  static const primary = Color(0xFF7DE3D2);
  static const blue = Color(0xFF6D8FFF);
  static const purple = Color(0xFF8582FF);
  static const coral = Color(0xFFFF9C7C);
  static const sky = Color(0xFF7DCBF1);
  static const ink = Color(0xFF0B2434);
  static const textPrimary = Color(0xFFF4F4FC);
  static const textSecondary = Color(0xFFADB2C7);
  static const textMuted = Color(0xFF858DA7);
  static const glassBorder = Color(0x30FFFFFF);
}

abstract final class AppGradients {
  static const primary = LinearGradient(
    colors: [AppColors.primary, AppColors.blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const mint = LinearGradient(
    colors: [Color(0xFF78E7D6), Color(0xFF2CAF9E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const violet = LinearGradient(
    colors: [Color(0xFFA5ADFF), Color(0xFF6664F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const glass = LinearGradient(
    colors: [Color(0x23FFFFFF), Color(0x0BFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
