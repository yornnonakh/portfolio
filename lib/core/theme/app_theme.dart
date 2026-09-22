import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static final darkTheme = _buildTheme(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.ink,
      secondary: AppColors.blue,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    dividerColor: const Color(0x18FFFFFF),
    snackBarBackground: AppColors.surface,
  );

  static final lightTheme = _buildTheme(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: Color(0xFF0055D6),
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
    ),
    textPrimary: AppColors.textPrimaryLight,
    textSecondary: AppColors.textSecondaryLight,
    textMuted: AppColors.textMutedLight,
    dividerColor: const Color(0x1F000000),
    snackBarBackground: AppColors.surfaceLight,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
    required ColorScheme colorScheme,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color dividerColor,
    required Color snackBarBackground,
  }) {
    final primaryColor = colorScheme.primary;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Outfit',
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          height: 1.08,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -.8,
          height: 1.25,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: textSecondary),
      ),
      splashFactory: NoSplash.splashFactory,
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBarBackground,
        contentTextStyle: TextStyle(
          fontFamily: 'Outfit',
          color: textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 400),
      ),
    );
  }
}
