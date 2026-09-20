import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Outfit',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.ink,
      secondary: AppColors.blue,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.2,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -.6,
        height: 1.25,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.6,
        color: AppColors.textSecondary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.4,
        color: AppColors.textMuted,
      ),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: AppColors.textSecondary),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0x18FFFFFF),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surface,
      contentTextStyle: const TextStyle(
        fontFamily: 'Outfit',
        color: AppColors.textPrimary,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    tooltipTheme: const TooltipThemeData(
      waitDuration: Duration(milliseconds: 400),
    ),
  );
}
